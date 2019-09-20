require 'date'

module CurrentDateTime
    def getCurrentDateTime
        return DateTime.now.strftime('%d/%m/%Y %H:%M:%S')
    end
end