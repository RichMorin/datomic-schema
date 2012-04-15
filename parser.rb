#!/usr/bin/env ruby

class Attribute
  def initialize(options)
    @entity = options[0]
    @attribute_name = options[1]
    @cardinality = options[2]
    @value_type = options[3]
    @unique = nil
    @index = nil
    @fulltext = nil
    @isComponent = nil
    @noHistory = nil
  end

  def unique=(uniq)
    @unique = uniq
  end

  def index=(ind)
    @index = ind
  end

  def fulltext=(ft)
    @fulltext = ft
  end

  def isComponent=(iC)
    @isComponent = iC
  end

  def noHistory=(nH)
    @noHistory = nh
  end

  def to_s
    base_str = %[ 
{:db/id #db/id[:db.part/db],
:db/ident :#{@entity}/#{@attribute_name},
:db/cardinality :db.cardinality/#{@cardinality},
:db/valueType :db.type/#{@value_type}
]
    if @unique
      base_str += ":db/unique :db.unique/#{@unique}\n"
    end
    if @index
      base_str += ":db/index true\n"
    end
    if @fulltext
      base_str += ":db/fulltext true\n"
    end
    if @isComponent
      base_str += ":db/isComponent true\n"
    end
    if @noHistory
      base_str += ":db/noHistory true\n"
    end
    base_str += ":db.install/_attribute :db.part/db}\n"
  end

end



file = File.open('schema.dtm', 'w')
file.write('[')
IO.foreach(ARGV[0]) do |line|
  unless line.length == 1
    if line[0] == 59
      file.write("\n" + line)
    else
      options = line.split
      attr = Attribute.new(options[0..3])
      if options.length > 4 then options[4..-1].each do |opt|
          case opt
          when "unique-id" then attr.unique = "identity"
          when "unique-val" then attr.unique = "value"
          when "index" then attr.index = "true"
          when "fulltext" then attr.fulltext = "true"
          when "component" then attr.isComponent = "true"
          when "noHistory" then attr.noHistory = "true"
          end
        end
      end
      file.write(attr)
    end
  end
end
file.write(']')
file.close
