require 'csv'
require_relative '../lib/transaction.rb'
require_relative '../lib/repo_method_helper.rb'
require 'pry'

class TransactionRepository
  attr_reader :list
  include RepoMethodHelper

  def initialize(list)
    @list = list
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.find_all do |each|
      each.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(result)
    all.find_all do |each|
      each.result == result.to_sym
    end
  end

  def create(attributes)
    @list << Transaction.new(
      id:                          create_id,
      created_at:                  Time.now.to_s,
      updated_at:                  Time.now.to_s,
      invoice_id:                  attributes[:invoice_id],
      credit_card_number:          attributes[:credit_card_number],
      credit_card_expiration_date: attributes[:credit_card_expiration_date],
      result:                      attributes[:result]
    )
  end

  def update(id, attributes)
    result = attributes[:result].to_sym
    find_by_id(id).result = result unless result.nil?
    cc_number = attributes[:credit_card_number]
    find_by_id(id).credit_card_number = cc_number unless cc_number.nil?
    exp = attributes[:credit_card_expiration_date]
    find_by_id(id).credit_card_expiration_date = exp unless exp.nil?
    find_by_id(id).updated_at = Time.now unless find_by_id(id).nil?
  end
end
