=begin
#The Plaid API

#The Plaid REST API. Please see https://plaid.com/docs/api for more details.

The version of the OpenAPI document: 2020-09-14_1.94.0

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 5.1.1

=end

require 'date'
require 'time'

module Plaid
  # A grouping of related transactions
  class TransactionStream
    # The ID of the account to which the stream belongs
    attr_accessor :account_id

    # A unique id for the stream
    attr_accessor :stream_id

    # The ID of the category to which this transaction belongs. See [Categories](https://plaid.com/docs/#category-overview).
    attr_accessor :category_id

    # A hierarchical array of the categories to which this transaction belongs. See [Categories](https://plaid.com/docs/#category-overview).
    attr_accessor :category

    # A description of the transaction stream.
    attr_accessor :description

    # The merchant associated with the transaction stream.
    attr_accessor :merchant_name

    # The posted date of the earliest transaction in the stream.
    attr_accessor :first_date

    # The posted date of the latest transaction in the stream.
    attr_accessor :last_date

    attr_accessor :frequency

    # An array of Plaid transaction IDs belonging to the stream, sorted by posted date.
    attr_accessor :transaction_ids

    attr_accessor :average_amount

    attr_accessor :last_amount

    # Indicates whether the transaction stream is still live.
    attr_accessor :is_active

    attr_accessor :status

    # Attribute mapping from ruby-style variable name to JSON key.
    def self.attribute_map
      {
        :'account_id' => :'account_id',
        :'stream_id' => :'stream_id',
        :'category_id' => :'category_id',
        :'category' => :'category',
        :'description' => :'description',
        :'merchant_name' => :'merchant_name',
        :'first_date' => :'first_date',
        :'last_date' => :'last_date',
        :'frequency' => :'frequency',
        :'transaction_ids' => :'transaction_ids',
        :'average_amount' => :'average_amount',
        :'last_amount' => :'last_amount',
        :'is_active' => :'is_active',
        :'status' => :'status'
      }
    end

    # Returns all the JSON keys this model knows about
    def self.acceptable_attributes
      attribute_map.values
    end

    # Attribute type mapping.
    def self.openapi_types
      {
        :'account_id' => :'String',
        :'stream_id' => :'String',
        :'category_id' => :'String',
        :'category' => :'Array<String>',
        :'description' => :'String',
        :'merchant_name' => :'String',
        :'first_date' => :'Date',
        :'last_date' => :'Date',
        :'frequency' => :'RecurringTransactionFrequency',
        :'transaction_ids' => :'Array<String>',
        :'average_amount' => :'TransactionStreamAmount',
        :'last_amount' => :'TransactionStreamAmount',
        :'is_active' => :'Boolean',
        :'status' => :'TransactionStreamStatus'
      }
    end

    # List of attributes with nullable: true
    def self.openapi_nullable
      Set.new([
      ])
    end

    # Initializes the object
    # @param [Hash] attributes Model attributes in the form of hash
    def initialize(attributes = {})
      if (!attributes.is_a?(Hash))
        fail ArgumentError, "The input argument (attributes) must be a hash in `Plaid::TransactionStream` initialize method"
      end

      # check to see if the attribute exists and convert string to symbol for hash key
      attributes = attributes.each_with_object({}) { |(k, v), h|
        if (!self.class.attribute_map.key?(k.to_sym))
          fail ArgumentError, "`#{k}` is not a valid attribute in `Plaid::TransactionStream`. Please check the name to make sure it's valid. List of attributes: " + self.class.attribute_map.keys.inspect
        end
        h[k.to_sym] = v
      }

      if attributes.key?(:'account_id')
        self.account_id = attributes[:'account_id']
      end

      if attributes.key?(:'stream_id')
        self.stream_id = attributes[:'stream_id']
      end

      if attributes.key?(:'category_id')
        self.category_id = attributes[:'category_id']
      end

      if attributes.key?(:'category')
        if (value = attributes[:'category']).is_a?(Array)
          self.category = value
        end
      end

      if attributes.key?(:'description')
        self.description = attributes[:'description']
      end

      if attributes.key?(:'merchant_name')
        self.merchant_name = attributes[:'merchant_name']
      end

      if attributes.key?(:'first_date')
        self.first_date = attributes[:'first_date']
      end

      if attributes.key?(:'last_date')
        self.last_date = attributes[:'last_date']
      end

      if attributes.key?(:'frequency')
        self.frequency = attributes[:'frequency']
      end

      if attributes.key?(:'transaction_ids')
        if (value = attributes[:'transaction_ids']).is_a?(Array)
          self.transaction_ids = value
        end
      end

      if attributes.key?(:'average_amount')
        self.average_amount = attributes[:'average_amount']
      end

      if attributes.key?(:'last_amount')
        self.last_amount = attributes[:'last_amount']
      end

      if attributes.key?(:'is_active')
        self.is_active = attributes[:'is_active']
      end

      if attributes.key?(:'status')
        self.status = attributes[:'status']
      end
    end

    # Show invalid properties with the reasons. Usually used together with valid?
    # @return Array for valid properties with the reasons
    def list_invalid_properties
      invalid_properties = Array.new
      if @account_id.nil?
        invalid_properties.push('invalid value for "account_id", account_id cannot be nil.')
      end

      if @stream_id.nil?
        invalid_properties.push('invalid value for "stream_id", stream_id cannot be nil.')
      end

      if @category_id.nil?
        invalid_properties.push('invalid value for "category_id", category_id cannot be nil.')
      end

      if @category.nil?
        invalid_properties.push('invalid value for "category", category cannot be nil.')
      end

      if @description.nil?
        invalid_properties.push('invalid value for "description", description cannot be nil.')
      end

      if @merchant_name.nil?
        invalid_properties.push('invalid value for "merchant_name", merchant_name cannot be nil.')
      end

      if @first_date.nil?
        invalid_properties.push('invalid value for "first_date", first_date cannot be nil.')
      end

      if @last_date.nil?
        invalid_properties.push('invalid value for "last_date", last_date cannot be nil.')
      end

      if @frequency.nil?
        invalid_properties.push('invalid value for "frequency", frequency cannot be nil.')
      end

      if @transaction_ids.nil?
        invalid_properties.push('invalid value for "transaction_ids", transaction_ids cannot be nil.')
      end

      if @average_amount.nil?
        invalid_properties.push('invalid value for "average_amount", average_amount cannot be nil.')
      end

      if @last_amount.nil?
        invalid_properties.push('invalid value for "last_amount", last_amount cannot be nil.')
      end

      if @is_active.nil?
        invalid_properties.push('invalid value for "is_active", is_active cannot be nil.')
      end

      if @status.nil?
        invalid_properties.push('invalid value for "status", status cannot be nil.')
      end

      invalid_properties
    end

    # Check to see if the all the properties in the model are valid
    # @return true if the model is valid
    def valid?
      return false if @account_id.nil?
      return false if @stream_id.nil?
      return false if @category_id.nil?
      return false if @category.nil?
      return false if @description.nil?
      return false if @merchant_name.nil?
      return false if @first_date.nil?
      return false if @last_date.nil?
      return false if @frequency.nil?
      return false if @transaction_ids.nil?
      return false if @average_amount.nil?
      return false if @last_amount.nil?
      return false if @is_active.nil?
      return false if @status.nil?
      true
    end

    # Checks equality by comparing each attribute.
    # @param [Object] Object to be compared
    def ==(o)
      return true if self.equal?(o)
      self.class == o.class &&
          account_id == o.account_id &&
          stream_id == o.stream_id &&
          category_id == o.category_id &&
          category == o.category &&
          description == o.description &&
          merchant_name == o.merchant_name &&
          first_date == o.first_date &&
          last_date == o.last_date &&
          frequency == o.frequency &&
          transaction_ids == o.transaction_ids &&
          average_amount == o.average_amount &&
          last_amount == o.last_amount &&
          is_active == o.is_active &&
          status == o.status
    end

    # @see the `==` method
    # @param [Object] Object to be compared
    def eql?(o)
      self == o
    end

    # Calculates hash code according to all attributes.
    # @return [Integer] Hash code
    def hash
      [account_id, stream_id, category_id, category, description, merchant_name, first_date, last_date, frequency, transaction_ids, average_amount, last_amount, is_active, status].hash
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def self.build_from_hash(attributes)
      new.build_from_hash(attributes)
    end

    # Builds the object from hash
    # @param [Hash] attributes Model attributes in the form of hash
    # @return [Object] Returns the model itself
    def build_from_hash(attributes)
      return nil unless attributes.is_a?(Hash)
      self.class.openapi_types.each_pair do |key, type|
        if attributes[self.class.attribute_map[key]].nil? && self.class.openapi_nullable.include?(key)
          self.send("#{key}=", nil)
        elsif type =~ /\AArray<(.*)>/i
          # check to ensure the input is an array given that the attribute
          # is documented as an array but the input is not
          if attributes[self.class.attribute_map[key]].is_a?(Array)
            self.send("#{key}=", attributes[self.class.attribute_map[key]].map { |v| _deserialize($1, v) })
          end
        elsif !attributes[self.class.attribute_map[key]].nil?
          self.send("#{key}=", _deserialize(type, attributes[self.class.attribute_map[key]]))
        end
      end

      self
    end

    # Deserializes the data based on type
    # @param string type Data type
    # @param string value Value to be deserialized
    # @return [Object] Deserialized data
    def _deserialize(type, value)
      case type.to_sym
      when :Time
        Time.parse(value)
      when :Date
        Date.parse(value)
      when :String
        value.to_s
      when :Integer
        value.to_i
      when :Float
        value.to_f
      when :Boolean
        if value.to_s =~ /\A(true|t|yes|y|1)\z/i
          true
        else
          false
        end
      when :Object
        # generic object (usually a Hash), return directly
        value
      when /\AArray<(?<inner_type>.+)>\z/
        inner_type = Regexp.last_match[:inner_type]
        value.map { |v| _deserialize(inner_type, v) }
      when /\AHash<(?<k_type>.+?), (?<v_type>.+)>\z/
        k_type = Regexp.last_match[:k_type]
        v_type = Regexp.last_match[:v_type]
        {}.tap do |hash|
          value.each do |k, v|
            hash[_deserialize(k_type, k)] = _deserialize(v_type, v)
          end
        end
      else # model
        # models (e.g. Pet) or oneOf
        klass = Plaid.const_get(type)
        klass.respond_to?(:openapi_one_of) ? klass.build(value) : klass.build_from_hash(value)
      end
    end

    # Returns the string representation of the object
    # @return [String] String presentation of the object
    def to_s
      to_hash.to_s
    end

    # to_body is an alias to to_hash (backward compatibility)
    # @return [Hash] Returns the object in the form of hash
    def to_body
      to_hash
    end

    # Returns the object in the form of hash
    # @return [Hash] Returns the object in the form of hash
    def to_hash
      hash = {}
      self.class.attribute_map.each_pair do |attr, param|
        value = self.send(attr)
        if value.nil?
          is_nullable = self.class.openapi_nullable.include?(attr)
          next if !is_nullable || (is_nullable && !instance_variable_defined?(:"@#{attr}"))
        end

        hash[param] = _to_hash(value)
      end
      hash
    end

    # Outputs non-array value in the form of hash
    # For object, use to_hash. Otherwise, just return the value
    # @param [Object] value Any valid value
    # @return [Hash] Returns the value in the form of hash
    def _to_hash(value)
      if value.is_a?(Array)
        value.compact.map { |v| _to_hash(v) }
      elsif value.is_a?(Hash)
        {}.tap do |hash|
          value.each { |k, v| hash[k] = _to_hash(v) }
        end
      elsif value.respond_to? :to_hash
        value.to_hash
      else
        value
      end
    end

  end

end
