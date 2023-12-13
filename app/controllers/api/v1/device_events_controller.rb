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

    end

    def device_event_params
        params.require(:device_event).permit(:category, :recorded_at)
    end
end
