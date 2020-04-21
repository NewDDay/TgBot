using HTTP
using JSON
using Telegrambot

function binance(symbol::AbstractString)
    u = "https://api.binance.com/api/v3/ticker/price?symbol="
    url = u .* symbol
    try
        res = HTTP.get(url)
        r = JSON.parse(String(res.body))
        return r["price"]
    catch
        return "Не найдено"
    end
end

function huobi(symbol::AbstractString)
    u = "https://api.huobi.pro/market/detail/merged?symbol="
    url = u .* lowercase(symbol)
    try
        res = HTTP.get(url)
        r = JSON.parse(String(res.body))
        return (r["tick"]["ask"][1] + r["tick"]["bid"][1])/2
    catch
        return "Не найдено"
    end
end

function welcomeMessage(incoming::AbstractString)
    return "Привет, этот бот создаётся для тренировки и служит для вывода курса биржи по символу \nПока тебе доступна только команда /price symbol"
end

function output(symbol::AbstractString)
    return "Котировки инструмента $symbol \nBinance - $(binance(symbol))\nHuobi - $(huobi(symbol))"
end

botApi = "1214087210:AAFqZ9gtQC_OmtOrUxRZ_tRikCC-RTIP9mk"
txtCmds = Dict()
txtCmds["start"] = welcomeMessage # this will respond to '/start'
txtCmds["price"] = output # this will respond to '/repeatmessage <any thing>'
inlineOpts = Dict() #Title, result pair
startBot(botApi; textHandle = txtCmds, inlineQueryHandle = inlineOpts)
