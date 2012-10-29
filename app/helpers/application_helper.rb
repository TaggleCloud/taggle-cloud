module ApplicationHelper
  
  def bootstrap_alerts(type)
    case type
      when :alert
        "alert-block"
      when :error
        "alert-error"
      when :notice
        "alert-info"
      when :success
        "alert-success"
      else
        type.to_s
    end
  end

  def link_to_add_fields(name, f, association)
    puts "called"
    new_object = f.object.send(association).klass.new
    puts "called 2"
    id = new_object.object_id
    puts "called 3"
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      puts "called 4"
      render(association.to_s.singularize + "_fields", f: builder)
    end
    puts id
    puts fields
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
