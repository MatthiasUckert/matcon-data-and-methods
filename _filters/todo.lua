-- Marks every placeholder value from _variables.yml (a word starting with TODO) so that the rendered page shows
-- the gap instead of hiding it. Runs after Quarto has resolved the {{< var >}} shortcodes.

local function mark(text)
  return pandoc.Span(
    { pandoc.Str(text) },
    pandoc.Attr("", { "todo" }, { title = "Placeholder: not decided yet" })
  )
end

function Str(el)
  local lead, word, tail = el.text:match("^(%p*)(TODO[%w%-_]*)(.*)$")
  if word == nil then
    return nil
  end
  local out = {}
  if lead ~= "" then
    table.insert(out, pandoc.Str(lead))
  end
  table.insert(out, mark(word))
  if tail ~= "" then
    table.insert(out, pandoc.Str(tail))
  end
  return out
end
