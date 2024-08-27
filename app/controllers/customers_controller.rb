# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show update destroy]

  # GET /customers
  def index
    @customers = Customer.includes(:custom_attributes).all
    render json: @customers.map { |customer| customer_with_custom_attributes(customer) }
  end

  # GET /customers/:id
  def show
    render json: customer_with_custom_attributes(@customer)
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      handle_successful_creation(@customer)
    else
      handle_creation_failure(@customer)
    end
  end

  # PUT /customers/:id
  def update
    if @customer.update(customer_params)
      begin
        handle_custom_attributes(@customer)
        render json: customer_with_custom_attributes(@customer), status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity and return
      end
    else
      render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /customers/:id
  def destroy
    @customer.destroy
    head :no_content
  end

  private

  def set_customer
    @customer = Customer.includes(:custom_attributes).find(params[:id])
  end

  # Strong parameters for the customer
  def customer_params
    params.require(:customer).permit(:name, :phone_number) # Only allow standard attributes
  end

  def handle_successful_creation(customer)
    handle_custom_attributes(customer)

    render json: customer_with_custom_attributes(customer), status: :created
  rescue StandardError => e
    logger.error("Failed to handle custom attributes: #{e.message}")
    render json: { error: 'An error occurred while processing custom attributes.' }, status: :unprocessable_entity
  end

  def handle_creation_failure(customer)
    render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_custom_attributes(resource)
    custom_attributes = params[:customer].except(:name, :phone_number) # Exclude standard params

    # Only set custom attributes and handle errors without rendering twice
    begin
      resource.set_custom_attributes(custom_attributes)
    rescue StandardError
    end
  end

  def customer_with_custom_attributes(customer)
    customer.attributes.merge(customer.custom_attributes_hash)
  end
end
