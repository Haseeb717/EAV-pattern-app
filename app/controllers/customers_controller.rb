# app/controllers/customers_controller.rb
class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  # GET /customers
  def index
    @customers = Customer.includes(:custom_attributes).all
    respond_to do |format|
      format.json { render json: @customers.map { |customer| customer_with_custom_attributes(customer) } }
    end
  end

  # GET /customers/:id
  def show
    respond_to do |format|
      format.json { render json: customer_with_custom_attributes(@customer) }
    end
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      handle_custom_attributes(@customer)

      respond_to do |format|
        format.json { render json: customer_with_custom_attributes(@customer), status: :created }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/:id
  def update
    if @customer.update(customer_params)
      handle_custom_attributes(@customer)

      respond_to do |format|
        format.json { render json: customer_with_custom_attributes(@customer), status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity }
      end
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

  def handle_custom_attributes(resource)
    # All other attributes from the customer hash are considered custom attributes
    custom_attributes = params[:customer].except(:name, :phone_number) # Exclude standard params

    begin
      resource.set_custom_attributes(custom_attributes)
    rescue => e
      # Handle error and ensure it doesn't interrupt flow
      render json: { error: e.message }, status: :unprocessable_entity and return
    end
  end

  def customer_with_custom_attributes(customer)
    customer.attributes.merge(customer.custom_attributes_hash)
  end
end
