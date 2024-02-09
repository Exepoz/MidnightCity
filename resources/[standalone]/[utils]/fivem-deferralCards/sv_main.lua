local DeferralCards = {
    Card = {},
    CardElement = {},
    Container = {},
    Action = {},
    Input = {}
}

function GetDefferalCards()
    return DeferralCards
end exports('DeferralCards', GetDefferalCards)

--------------------------------------------------[[ Cards ]]--------------------------------------------------

DeferralCards.Card.Create = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'AdaptiveCard'
    pOptions.version = pOptions.version or '1.4'
    pOptions.body = pOptions.body or {}
    pOptions['$schema'] = 'http://adaptivecards.io/schemas/adaptive-card.json'
    return json.encode(pOptions)
end
--[[
    DeferralCards.Card:Create({
        body = {
            DeferralCards.CardElement:Image({
                url = '',
                size = 'small',
                horizontalAlignment = 'center'
            }),
            DeferralCards.CardElement:TextBlock({
                text = 'Text',
                weight = 'Light',
                horizontalAlignment = 'center'
            }),
        }
    })
]]

--------------------------------------------------[[ Card Elements ]]--------------------------------------------------

DeferralCards.CardElement.TextBlock = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'TextBlock'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end
--[[
    DeferralCards.CardElement:TextBlock({
        size = 'small',
        weight = 'Light',
        text = 'Some text',
        wrap = true
    })
]]

DeferralCards.CardElement.Image = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Image'
    pOptions.url = pOptions.url or 'https://via.placeholder.com/100x100?text=Temp+Image'
    return pOptions
end
--[[
    DeferralCards.CardElement:Image({
        url = 'https://via.placeholder.com/100x100?text=Temp+Image'
    })
]]

DeferralCards.CardElement.Media = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Media'
    pOptions.sources = pOptions.sources or {}
    return pOptions
end
--[[
    DeferralCards.CardElement:Media({
        poster = 'https://adaptivecards.io/content/poster-video.png',
        sources = {}
    })
]]

DeferralCards.CardElement.MediaSource = function(self, pOptions)
    if not pOptions then return end
    pOptions.mimeType = pOptions.mimeType or 'video/mp4'
    pOptions.url = pOptions.url or ''
    return pOptions
end
--[[
    DeferralCards.CardElement:MediaSource({
        mimeType = 'video/mp4',
        url = ''
    })
]]

DeferralCards.CardElement.RichTextBlockItem = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'TextRun'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end
--[[
    DeferralCards.CardElement:RichTextBlockItem({
        text = 'Item 1',
        size = 'small',
        color = 'good',
        isSubtle = true,
        weight = 'small',
        highlight = true,
        italic = false,
        strikethrough = false,
        fontType = 'monospace'
    })
]]

DeferralCards.CardElement.RichTextBlock = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'RichTextBlock'
    pOptions.inline = pOptions.inline or {}
    return pOptions
end
--[[
    DeferralCards.CardElement:RichTextBlock({
        horizontalAlignment = 'center',
        inline = {
            DeferralCards.CardElement:RichTextBlockItem({
                text = 'Item 1',
                size = 'small',
                color = 'good',
                isSubtle = true,
                weight = 'small',
                highlight = true
            }),
            DeferralCards.CardElement:RichTextBlockItem({
                text = 'Item 2',
                size = 'medium',
                color = 'good',
                isSubtle = false,
                weight = 'large',
                highlight = false
            })
        }
    })
]]

DeferralCards.CardElement.TextRun = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'TextRun'
    pOptions.text = pOptions.text or 'Text'
    return pOptions
end
--[[
    DeferralCards.CardElement:TextRun({
        text = 'Text',
        color = 'good',
        fontType = 'monospace',
        highlight = false,
        isSubtle = false,
        italic = false,
        size = 'small',
        strikethrough = false,
        underline = false,
        weight = 'medium'
    })
]]

--------------------------------------------------[[ Containers ]]--------------------------------------------------

DeferralCards.Container.Create = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Container'
    pOptions.items = pOptions.items or {}
    return pOptions
end
--[[
    DeferralCards.Container:Create({
        items = {}
    })
]]

DeferralCards.Container.ActionSet = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'ActionSet'
    pOptions.actions = pOptions.actions or {}
    return pOptions
end
--[[
    DeferralCards.Container:ActionSet({
        actions = {},
    })
]]

DeferralCards.Container.ColumnSet = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'ColumnSet'
    pOptions.columns = pOptions.columns or {}
    return pOptions
end
--[[
    DeferralCards.Container:ColumnSet({
        columns = {}
    })
]]

DeferralCards.Container.Column = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Column'
    pOptions.items = pOptions.items or {}
    return pOptions
end
--[[
    DeferralCards.Container:Column({
        items = {},
        width = 'auto'
    })
]]

DeferralCards.Container.Fact = function(self, pOptions)
    if not pOptions then return end
    pOptions.title = pOptions.title or 'Title'
    pOptions.value = pOptions.value or 'Value'
    return pOptions
end
--[[
    DeferralCards.Container:Fact({
        title = 'Title',
        value = 'Value'
    })
]]

DeferralCards.Container.FactSet = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'FactSet'
    pOptions.facts = pOptions.facts or {}
    return pOptions
end
--[[
    DeferralCards.Container:FactSet({
        facts = {
            DeferralCards.Container:Fact({
                title = 'Title 1',
                value = 'Value 1'
            }),
            DeferralCards.Container:Fact({
                title = 'Title 2',
                value = 'Value 2'
            })
        }
    })
]]

DeferralCards.Container.ImageSetItem = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = pOptions.type or 'Image'
    pOptions.url = pOptions.url or 'https://adaptivecards.io/content/cats/1.png'
    return pOptions
end
--[[
    DeferralCards.Container:ImageSetItem({
        type = 'Image',
        url = 'https://adaptivecards.io/content/cats/1.png'
    })
]]

DeferralCards.Container.ImageSet = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'ImageSet'
    pOptions.images = pOptions.images or {}
    return pOptions
end
--[[
    DeferralCards.Container:ImageSet({
        images = {
            DeferralCards.Container:ImageSetItem({
                type = 'Image',
                url = 'https://adaptivecards.io/content/cats/1.png'
            }),
            DeferralCards.Container:ImageSetItem({
                type = 'Image',
                url = 'https://adaptivecards.io/content/cats/2.png'
            })
        }
    })
]]

--------------------------------------------------[[ Actions ]]--------------------------------------------------

DeferralCards.Action.OpenUrl = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.OpenUrl'
    pOptions.url = pOptions.url or 'https://www.google.co.uk/'
    return pOptions
end
--[[
    DeferralCards.Action:OpenUrl({
        title = 'Title',
        url = 'https://www.google.co.uk/'
    })
]]

DeferralCards.Action.Submit = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.Submit'
    return pOptions
end
--[[
    DeferralCards.Action:Submit({
        title = 'Title',
        data = {
            x = 10
        }
    })
]]

DeferralCards.Action.ShowCard = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.ShowCard'
    return pOptions
end
--[[
    DeferralCards.Action:ShowCard({
        title = 'Title',
        card = {}
    })
]]

DeferralCards.Action.TargetElement = function(self, pOptions)
    if not pOptions then return end
    pOptions.elementId = pOptions.elementId or 'target_element'
    return pOptions
end
--[[
    DeferralCards.Action:TargetElement({
        elementId = 'element_1',
        isVisible = true
    })
]]

DeferralCards.Action.ToggleVisibility = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.ToggleVisibility'
    pOptions.targetElements = pOptions.targetElements or {}
    return pOptions
end
--[[
    DeferralCards.Action:ToggleVisibility({
        title = 'Title',
        targetElements = {
            Deferralcards.Action:TargetElement({
                elementId = 'element_1',
                isVisible = true
            }),
            Deferralcards.Action:TargetElement({
                elementId = 'element_2',
                isVisible = true
            })
        }
    })
]]

DeferralCards.Action.Execute = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Action.Execute'
    return pOptions
end
--[[
    DeferralCards.Action:Execute({
        title = 'Title',
        verb = 'Verb',
        data = {
            x = 10
        }
    })
]]

--------------------------------------------------[[ Inputs ]]--------------------------------------------------

DeferralCards.Input.Text = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Text'
    pOptions.id = pOptions.id or 'input_text'
    return pOptions
end

DeferralCards.Input.Password = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Text'
    pOptions.style = 'Password'
    pOptions.id = pOptions.id or 'input_text'
    return pOptions
end

--[[
    DeferralCards.Input:Text({
        id = 'input_text',
        text = 'Text',
        title = 'Title',
        placeholder = 'Placeholder'
    })
]]

DeferralCards.Input.Number = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Number'
    pOptions.id = pOptions.id or 'input_number'
    return pOptions
end
--[[
    DeferralCards.Input:Number({
        id = 'input_number',
        placeholder = 'Placeholder',
        min = 1,
        max = 10,
        value = 5
    })
]]

DeferralCards.Input.Date = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Date'
    pOptions.id = pOptions.id or 'input_date'
    return pOptions
end
--[[
    DeferralCards.Input:Date({
        id = 'input_date',
        placeholder = 'Placeholder',
        value = '2021-08-13'
    })
]]

DeferralCards.Input.Time = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Time'
    pOptions.id = pOptions.id or 'input_time'
    return pOptions
end
--[[
    DeferralCards.Input:Time({
        id = 'input_time',
        placeholder = 'Placeholder',
        min = '00:00',
        max = '23:59',
        value = '19:00'
    })
]]

DeferralCards.Input.Toggle = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.Toggle'
    pOptions.title = pOptions.title or 'Title'
    pOptions.id = pOptions.id or 'input_toggle'
    return pOptions
end
--[[
    DeferralCards.Input:Toggle({
        id = 'input_toggle',
        title = 'Title',
        value = 'true',
        valueOn = 'true',
        valueOff = 'false'
    })
]]

DeferralCards.Input.Choice = function(self, pOptions)
    if not pOptions then return end
    pOptions.title = pOptions.title or 'Title'
    pOptions.value = pOptions.value or 'Value'
    return pOptions
end
--[[
    DeferralCards.Input:Choice({
        title = 'Title',
        value = 'Value'
    })
]]

DeferralCards.Input.ChoiceSet = function(self, pOptions)
    if not pOptions then return end
    pOptions.type = 'Input.ChoiceSet'
    pOptions.choices = pOptions.choices or {}
    pOptions.id = pOptions.id or 'choice_set'
    return pOptions
end
--[[
    DeferralCards.Input:ChoiceSet({
        placeholder = 'Text',
        choices = {
            DeferralCards.Input:Choice({
                title = 'Title 1',
                value = 'Value 1'
            }),
            DeferralCards.Input:Choice({
                title = 'Title 2',
                value = 'Value 2'
            })
        }
    })
]]