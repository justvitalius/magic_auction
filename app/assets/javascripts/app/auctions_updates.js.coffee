$ ->
  PrivatePub.subscribe '/auctions/updates', (data, channel) ->
    $("#auction_#{data.auction_id} .js-auction-price").text(data.auction_price)
    $("#auction_#{data.auction_id} .js-auction-finish-date").text(data.auction_finish_date)