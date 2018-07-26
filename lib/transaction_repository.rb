require 'csv'
require_relative '../lib/transaction.rb'
require_relative '../lib/repo_method_helper.rb'
require 'pry'

class TransactionRepository

  attr_reader :transactions
  include RepoMethodHelper

  def initialize(transaction_location)
    @transaction_location = transaction_location
    @transactions = []
    from_sales_engine
  end

  def from_sales_engine
    CSV.foreach(@transaction_location, headers: true, header_converters: :symbol) do |row|
      @transactions << Transaction.new(row)
    end
  end

  def all
    @transactions
  end

  def find_all_by_invoice_id(invoice_id)
    all.find_all do |each|
      each.invoice_id.to_i == invoice_id
    end
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.find_all do |each|
      each.credit_card_number.to_i == credit_card_number
    end
  end

  def find_all_by_result(result)
    all.find_all do |each|
      each.result == result.to_sym
    end
  end

  def create(attributes)
    attributes[:id] = create_id
    attributes[:created_at] = Time.now.to_s
    attributes[:updated_at] = Time.now.to_s
    created = Transaction.new(attributes)
    @transactions << created
    created
  end

  def update(id, attributes)
    find_by_id(id).result = attributes[:result].to_sym unless attributes[:result].nil?
    find_by_id(id).credit_card_number = attributes[:credit_card_number].to_i unless attributes[:credit_card_number].nil?
    find_by_id(id).credit_card_expiration_date = attributes[:credit_card_expiration_date].to_i unless attributes[:credit_card_expiration_date].nil?
    find_by_id(id).updated_at = Time.now unless find_by_id(id).nil?
  end
end