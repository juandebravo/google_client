require 'google_client'
require 'spec_helper'
require 'webmock/rspec'

describe GoogleClient::Contact do

  let(:contact_params) do
    {
      :email => "juandebravo@gmail.com",
      :name => ["Juan de Bravo"],
      :phone_number => ["+34667788999"]
    }
  end

  describe "while initializing" do
    it "should set the parameters properly" do
      contact = GoogleClient::Contact.new(contact_params)
      contact.should be_instance_of(GoogleClient::Contact)
      contact.should have_valid_attributes contact_params[:name], contact_params[:email], contact_params[:phone_number]
    end

    it "should set the phone_number properly as an Array" do
      params = contact_params.dup
      params[:phone_number] = ["+34667788999", "+34667788900"]
      contact = GoogleClient::Contact.new(contact_params)
      contact.should be_instance_of(GoogleClient::Contact)
      contact.should have_valid_attributes contact_params[:name], contact_params[:email], contact_params[:phone_number]
    end

    it "should set the email properly as an Array" do
      params = contact_params.dup
      params[:email] = ["juandebravo@gmail.com", "juandebravo+1@gmail.com"]
      contact = GoogleClient::Contact.new(params)
      contact.should be_instance_of(GoogleClient::Contact)
      contact.should have_valid_attributes params[:name], params[:email], params[:phone_number]
    end
  end

end