# frozen_string_literal: true

class CustomersController < ApplicationController
  before_action :set_customer, only: %i[show update destroy]

  # GET /customers
  def index
    @customers = Customer.includes(:custom_attributes).all
    render json: CustomerSerializer.new(@customers).serializable_hash
  end

  # GET /customers/:id
  def show
    render json: CustomerSerializer.new(@customer).serializable_hash
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    handle_result(@customer.save, @customer, :created)
  end

  # PUT /customers/:id
  def update
    handle_result(@customer.update(customer_params), @customer, :ok)
  end

  # DELETE /customers/:id
  def destroy
    @customer.destroy
    head :no_content
  end

  private

  def set_customer
    @customer = Customer.includes(:custom_attributes).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Customer not found' }, status: :not_found
  end

  # Strong parameters for the customer
  def customer_params
    params.require(:customer).permit(:name, :phone_number) # Only allow standard attributes
  end

  def handle_result(success, customer, success_status)
    if success
      handle_custom_attributes(customer)
      render json: CustomerSerializer.new(customer).serializable_hash, status: success_status
    else
      render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    logger.error("Failed to handle custom attributes: #{e.message}")
    render json: { error: 'An error occurred while processing custom attributes.' }, status: :unprocessable_entity
  end

  def handle_custom_attributes(resource)
    custom_attributes = params[:customer].except(:name, :phone_number) # Exclude standard params
    resource.set_custom_attributes(custom_attributes) if custom_attributes.present?
  end
end
