-- bold-author.lua
-- 1. Bolds "Del Castillo" (all name variants) within reference list entries.
-- 2. Splits #refs into featured entries (1st/2nd author) and a <details> block
--    for all others. Works automatically with Paperpile-synced references.bib.

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

-- Returns true if "Del Castillo" is the 1st or 2nd author.
-- Heuristic: count "., " occurrences before "Del Castillo" in the entry text.
-- Harvard cite-them-right separates authors with "., " (e.g. "Smith, J., Jones, B., …"),
-- so the pattern after each author's last initial is "., " (period-comma-space):
--   0 occurrences → first author
--   1 occurrence  → second author
--   2+            → third author or beyond
local function is_featured(div)
  local text = pandoc.utils.stringify(div)
  local pos = text:find("Del Castillo")
  if not pos then return false end
  local before = text:sub(1, pos - 1)
  local count = 0
  for _ in before:gmatch("%., ") do count = count + 1 end
  return count <= 1
end

function Div(div)
  -- Bold author name in individual csl-entry divs
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

  -- Restructure #refs: featured entries first, others in <details> block
  if div.identifier == "refs" then
    local featured = {}
    local other = {}

    for _, block in ipairs(div.content) do
      if block.t == "Div" and block.classes:includes("csl-entry") then
        if is_featured(block) then
          table.insert(featured, block)
        else
          table.insert(other, block)
        end
      end
    end

    local new_content = {}
    for _, entry in ipairs(featured) do
      table.insert(new_content, entry)
    end

    if #other > 0 then
      table.insert(new_content, pandoc.RawBlock("html",
        '<p class="pub-see-all"><a href="publications.html">See all publications →</a></p>'))
    end

    div.content = new_content
    return div
  end
end
