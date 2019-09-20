module RandomString
    def getRandomString(length=36)
        return rand(36**length).to_s(36)
    end
end
