class Api::V1::DeviceEventsController < ApplicationController
    def create 
        device_event = DeviceEvent.new(device_event_params)
        if device_event.save
            render json: device_event, status: :ok
        else 
            render json: device_event.errors, status: :unprocessable_entity
        end 
    end

    def update_notification
        @device_event = DeviceEvent.find(params[:id])
    
        if @device_event.notification_sent?
            render json: { error: "Notification has already been sent for this event" }, status: :unprocessable_entity
        else
            if @device_event.update(notification_sent: true)
                render json: @device_event, status: :ok
            else
                render json: { error: "Failed to update notification status" }, status: :bad_request
            end
        end
    end

    def device_event_params
        params.require(:device_event).permit(:category, :recorded_at)
    end
end
