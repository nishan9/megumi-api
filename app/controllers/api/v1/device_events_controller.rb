class Api::V1::DeviceEventsController < ApplicationController

    def index
        #if page is not a positive integer default to 1.
        page = params[:page].to_i.positive? ? params[:page].to_i : 1
        #max default and offset to skip accordingly
        per_page = 2
        offset = (page - 1) * per_page
        @device_events = DeviceEvent.filter_by_params(params).limit(per_page).offset(offset)
        render json: @device_events, status: :ok
    end

    def create 
        device_event = DeviceEvent.new(device_event_params)
        if device_event
            if device_event.save
                render json: device_event, status: :ok
            else 
                render json: device_event.errors, status: :unprocessable_entity
            end 
        else
            render json: { error: 'Device Event not found' }, status: :not_found
        end
    end

    def update
        #updates notification to true
        device_event = DeviceEvent.find(params[:id])
        if device_event
            if device_event.notification_sent?
                render json: { error: "Notification has already been sent for this event" }, status: :unprocessable_entity
            else
                if device_event.update(notification_sent: true)
                    render json: device_event, status: :ok
                else
                    render json: { error: "Failed to update notification status" }, status: :bad_request
                end
            end
        else
            render json: device_event.errors, status: :not_found
        end
    end

    def show
        device_event = DeviceEvent.find_by(uuid: params[:id])
        if device_event
            render json: device_event, status: :ok
        else
            render json: { error: 'Device Event not found' }, status: :not_found
        end
    end

    def destroy
        device_event = DeviceEvent.find(params[:id])
        if device_event
            if device_event.is_deleted?
                render json: { error: "This event has already been deleted" }, status: :unprocessable_entity
            else
                if device_event.update(is_deleted: true)
                    render status: :no_content
                else
                    render json: { error: "Failed to delete event" }, status: :bad_request
                end
            end
        else 
            render json: { error: 'Device Event not found' }, status: :not_found  
        end
    end

    def export_events

        begin
            Aws.config.update({
                region: 'eu-west-1',
                credentials: Aws::Credentials.new('', '')
            })

            bucket_name = 'sky-protect-2'
            s3_client = Aws::S3::Client.new(region: 'eu-west-1')

            #TODO (nishan.m) needs to be paginated and tested
            record = DeviceEvent.all
            file_name = "device_events"
            local_file_path = "/tmp/#{file_name}"

            File.open(local_file_path, 'w') do |file| 
                file.write(record.to_json)
            end

            File.open(local_file_path, 'rb') do |file|
                s3_client.put_object(bucket: bucket_name, key: file_name, body: file)
            end

            render status: :no_content

            rescue StandardError => e
                render json: { error: "File failed to export. #{e.message}" }, status: :internal_server_error
        end   
    end

    def device_event_params
        params.require(:device_event).permit(:category, :recorded_at)
    end
end