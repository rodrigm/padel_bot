module Canal
  class SearchAction
    def initialize(api_handler)
      @api_handler = api_handler
    end

    def handle_command(args_a=nil, reply)
      return {} unless args_a && reply
      reply_text = ""
      time_s = args_a.first
      force_reply = false
      if time_s
        reply_text = "Searching available dates.."
        reply_text << find_availability(time_s, reply)
      else
        reply_text = "Cool, give me a time"
        force_reply = true
      end
      { reply: reply_text, force_reply: force_reply }
    end

    def find_availability(time_s, reply)
      date = Date.today
      limit_date = Date.today.next_day(7)
      found_str = ""
      while date < limit_date
        date_t = DateParser.parse_date_and_time(date.strftime("%d-%m-%Y"), time_s)
        if date_t
          msg_h = @api_handler.book_date(date_t)
          found_str << "\n\n #{date_t.full_date_string}: " + msg_h[:ok] if msg_h[:ok]
          date = date.next_day
        end
      end
      reply_text = found_str.empty? ? "No available dates" : found_str + "\n\n ---"
    end

    def cancel
    end
  end
end
