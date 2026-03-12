-- bold-only.lua
-- Bolds "Del Castillo" (all name variants) in csl-entry divs.
-- Used for the standalone publications page — no featured/other splitting.

local function bold_del_castillo(inlines)
  local result = {}
  local i = 1
  local n = #inlines

  while i <= n do
    local el = inlines[i]

    -- Match: Str("Del") + Space + Str("Castillo...")
    if el.t == "Str" and el.text == "Del"
       and i + 2 <= n
       and inlines[i + 1].t == "Space"
       and inlines[i + 2].t == "Str"
       and inlines[i + 2].text:match("^Castillo") then

      local bold_parts = { inlines[i], inlines[i + 1], inlines[i + 2] }
      i = i + 3

      -- Bare "Castillo" may be followed by Space + "Fernández..." variant
      if inlines[i - 1].text == "Castillo"
         and i + 1 <= n
         and inlines[i].t == "Space"
         and inlines[i + 1].t == "Str"
         and inlines[i + 1].text:match("^Fern") then
        table.insert(bold_parts, inlines[i])
        table.insert(bold_parts, inlines[i + 1])
        i = i + 2
      end

      -- Optionally include given name / initial: Space + "D." or "Darwin"
      if i + 1 <= n
         and inlines[i].t == "Space"
         and inlines[i + 1].t == "Str"
         and (inlines[i + 1].text:match("^D%.") or inlines[i + 1].text:match("^Darwin")) then
        table.insert(bold_parts, inlines[i])
        table.insert(bold_parts, inlines[i + 1])
        i = i + 2
      end

      table.insert(result, pandoc.Strong(bold_parts))
    else
      table.insert(result, el)
      i = i + 1
    end
  end

  return result
end

function Div(div)
  if div.classes:includes("csl-entry") then
    local new_content = {}
    for _, block in ipairs(div.content) do
      if block.t == "Para" or block.t == "Plain" then
        block.content = bold_del_castillo(block.content)
      end
      table.insert(new_content, block)
    end
    div.content = new_content
    return div
  end
end
