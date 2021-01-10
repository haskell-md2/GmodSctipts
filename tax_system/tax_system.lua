if SERVER then

    -- Дальнейшая логика приложения
    local tax_proc = 0.3; -- процент налога 


    -- хук, отлавливающий события из DarkRP 
    -- (playerWalletChanged), 
    -- смотреть на https://darkrp.miraheze.org/wiki/Hooks/Server/playerWalletChanged
    hook.Add("playerWalletChanged", "hook", function(ply,amount,wallet)

            -- ply - Игрок, получающий деньги.
            -- amount - Сумма денег, отданная игроку.
            -- wallet - Сколько денег было у игрока до получения денег.
            if amount > 0 and not ply:isMayor() then -- также налог не распространяется на мэра

                -- сумма, которую вычитаем 
                -- у получателем, и даём мэру
                local tax_sum = amount*tax_proc; 


                --отправляем деньги мэру
                --сначала находим его
                for i, v in ipairs( player.GetAll() ) do
                    if v:isMayor() then
                        v:addMoney(tax_sum); -- отправляем мэру
                        break; -- останавливаем цикл
                    end
                end

                -- просто сообщение для получателя, можно опустить. 
                ply:SendLua('notification.AddLegacy( "'.."Вы получили "..DarkRP.formatMoney(amount-tax_sum or 0).." (налог: "..(tax_proc*100).."%)"..'", 4, 5 )'); 
            
                return wallet+amount-tax_sum; -- установка баланса получателя
            end
            
    end); 

end

