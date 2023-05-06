function BuyById(itemId, times, delay)
    local itemIndex
    for i = 1, GetMerchantNumItems() do
        local link = GetMerchantItemLink(i)
        if link then
            local id = GetItemInfoInstant(link)
            if id == itemId then
                itemIndex = i
                break -- Exit the loop
            end
        end
    end

    if itemIndex then
        return C_Timer.NewTicker(delay, function()
            BuyMerchantItem(itemIndex, 1)
        end, times)
    else
        return nil
    end
end

function SellById(itemId, delay)
    local count = 0
    for bag = 0, NUM_BAG_SLOTS do
        for slot = 1, C_Container.GetContainerNumSlots(bag) do
            local id = C_Container.GetContainerItemID(bag, slot)
            if id == itemId then
                count = count + 1
                C_Timer.After(delay * (count - 1), function()
                    C_Container.UseContainerItem(bag, slot) -- Sell the item
                end)
            end
        end
    end
end

function BuySellById(itemId, times, delay)
    BuyById(itemId, times, delay)

    C_Timer.After(delay * times + 5, function()
        SellById(itemId, delay)
    end)
end

function test()
    -- print("test BuySellById ")
    -- /run BuyById(205918, 10, 0.25)
    -- /run SellById(205918, 0.25)

    local itemId = 205918
    local times = 120
    local interval = 0.3
    local interval_l = times * interval * 2 + 10

    for i = 0, 2000 do
        C_Timer.After(i * interval_l, function()
            BuySellById(itemId, times, interval)
        end)
    end
end