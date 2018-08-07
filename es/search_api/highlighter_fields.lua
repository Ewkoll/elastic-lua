local object = require "es.object"

local highlighter_fields = object:extend()

--[[
    boundary_chars
        A string that contains each boundary character. Defaults to .,!? \t\n.

    boundary_max_scan
        How far to scan for boundary characters. Defaults to 20.
    
    boundary_scanner
        设置如何断开高亮片段，只在unified 和 fvh 模式下有效。
        Specifies how to break the highlighted fragments: chars, sentence, or word.
        Only valid for the <!--unified and fvh--!> highlighters.
        
        Defaults to sentence for the unified highlighter.
        Defaults to chars for the fvh highlighter.

        chars
        Use the characters specified by boundary_chars as highlighting boundaries.
        The boundary_max_scan setting controls how far to scan for boundary characters.
        Only valid for the fvh highlighter.

        sentence
        Break highlighted fragments at the next sentence boundary, as determined by Java’s BreakIterator.
        You can specify the locale to use with boundary_scanner_locale.

        word
        Break highlighted fragments at the next word boundary, as determined by Java’s BreakIterator.
        You can specify the locale to use with boundary_scanner_locale.

    boundary_scanner_locale
        Controls which locale is used to search for sentence and word boundaries.
        This parameter takes a form of a language tag, e.g. "en-US", "fr-FR", "ja-JP".
        More info can be found in the Locale Language Tag documentation. The default value is Locale.ROOT.

    encoder
        Indicates if the snippet should be HTML encoded: default (no encoding) or html
        (HTML-escape the snippet text and then insert the highlighting tags)

    force_source
        Highlight based on the source even if the field is stored separately. Defaults to false.

    fragmenter
        高亮部分是否分离为多个数组
        Specifies how text should be broken up in highlight snippets: simple or span.
        Only valid for the plain highlighter. Defaults to span.

        simple
        Breaks up text into same-sized fragments.

        span
        Breaks up text into same-sized fragments, but tried to avoid breaking up text between highlighted terms.
        This is helpful when you’re querying for phrases. Default.

    fragment_offset
        Controls the margin from which you want to start highlighting.
        Only valid when using the fvh highlighter.

    fragment_size
        The size of the highlighted fragment in characters. Defaults to 100.

    highlight_query
        Highlight matches for a query other than the search query. This is especially useful if you use a rescore query
        because those are not taken into account by highlighting by default.
    
    matched_fields
        Combine matches on multiple fields to highlight a single field. This is most intuitive for multifields that
        analyze the same string in different ways. All matched_fields must have term_vector set to
        with_positions_offsets, but only the field to which the matches are combined is loade
        so only that field benefits from having store set to yes.
        Only valid for the fvh highlighter.

    no_match_size
        The amount of text you want to return from the beginning of the field if there are no matching fragments to
        highlight. Defaults to 0 (nothing is returned).
    
    number_of_fragments
        The maximum number of fragments to return. If the number of fragments is set to 0, no fragments are returned.
        Instead, the entire field contents are highlighted and returned. This can be handy when you need to highlight
        short texts such as a title or address, but fragmentation is not required. If number_of_fragments is 0,
        fragment_size is ignored. Defaults to 5.
    
    order
        Sorts highlighted fragments by score when set to score. By default, fragments will be output in the order they
        appear in the field (order: none). Setting this option to score will output the most relevant fragments first.
        Each highlighter applies its own logic to compute relevancy scores. See the document How highlighters work
        internally for more details how different highlighters find the best fragments.

    phrase_limit
        Controls the number of matching phrases in a document that are considered. Prevents the fvh highlighter from
        analyzing too many phrases and consuming too much memory. When using matched_fields,
        phrase_limit phrases per matched field are considered. Raising the limit increases query time and consumes more
        memory. Only supported by the fvh highlighter. Defaults to 256.

    pre_tags
        Use in conjunction with post_tags to define the HTML tags to use for the highlighted text. By default,
        highlighted text is wrapped in <em> and </em> tags. Specify as an array of strings.

    post_tags
        Use in conjunction with pre_tags to define the HTML tags to use for the highlighted text. By default,
        highlighted text is wrapped in <em> and </em> tags. Specify as an array of strings.
    
    require_field_match
        By default, only fields that contains a query match are highlighted. Set require_field_match to false to
        highlight all fields. Defaults to true.

    tags_schema
        Set to styled to use the built-in tag schema. The styled schema defines the following pre_tags and defines
        post_tags as </em>.

    type
        The highlighter to use: unified, plain, or fvh. Defaults to unified.
--]]
function highlighter_fields:new(key_name)
    highlighter_fields.super.new(self, "highlighter_fields")
    highlighter_fields._key_name = key_name
end

function highlighter_fields:encoder(encoder)
    if nil ~= encoder and self:is_string(encoder) then
        if "default" == encoder or "html" == encoder then
            highlighter_fields._encoder = encoder
        end
    end
    return self
end

function highlighter_fields:force_source(force_source)
    if nil ~= force_source and self:is_boolean(force_source) then
        highlighter_fields._force_source = force_source
    end
    return self
end

function highlighter_fields:fragmenter(fragmenter)
    if nil ~= fragmenter and self:is_string(fragmenter) then
        if "simple" == fragmenter or "span" == fragmenter then
            highlighter_fields._fragmenter = fragmenter
        end
    end
    return self
end

function highlighter_fields:fragment_size(fragment_size)
    if nil ~= fragment_size and self:is_number(fragment_size) then
        highlighter_fields._fragment_size = fragment_size
    end
    return self
end

function highlighter_fields:highlight_query(highlight_query)
    if nil ~= highlight_query then
        highlighter_fields._highlight_query = highlight_query
    end
    return self
end

function highlighter_fields:no_match_size(no_match_size)
    if nil ~= no_match_size and self:is_number(no_match_size) then
        highlighter_fields._no_match_size = no_match_size
    end
    return self
end

function highlighter_fields:number_of_fragments(number_of_fragments)
    if nil ~= number_of_fragments and self:is_number(number_of_fragments) then
        highlighter_fields._number_of_fragments = number_of_fragments
    end
    return self
end

function highlighter_fields:order()
    highlighter_fields._order = "score"
    return self
end

function highlighter_fields:phrase_limit(phrase_limit)
    if nil ~= phrase_limit and self:is_number(phrase_limit) then
        highlighter_fields._phrase_limit = phrase_limit
    end
    return self
end

function highlighter_fields:pre_tags(pre_tags)
    if nil == pre_tags then
        return self
    end

    if self:is_table(pre_tags) then
        highlighter_fields._pre_tags = pre_tags
    end

    if self:is_string(pre_tags) then
        highlighter_fields._pre_tags = {pre_tags}
    end
    return self
end

function highlighter_fields:post_tags(post_tags)
    if nil == post_tags then
        return self
    end

    if self:is_table(post_tags) then
        highlighter_fields._post_tags = post_tags
    end

    if self:is_string(post_tags) then
        highlighter_fields._post_tags = {post_tags}
    end
    return self
end

function highlighter_fields:require_field_match(require_field_match)
    if nil ~= require_field_match and self:is_boolean(require_field_match) then
        highlighter_fields._require_field_match = require_field_match
    end
    return self
end

function highlighter_fields:type(type)
    if nil == type or not self:is_string(type) then
        return self
    end

    if "unified" ~= type and "plain" ~= type and "fvh" ~= type then
        return self
    end

    highlighter_fields._type = type
    return self
end

function highlighter_fields:fill_content(table, key, object_content)
    if nil == object_content or nil == object_content.to_content then
        return
    end

    self:fill_object(table, key, object_content:to_content())
end

function highlighter_fields:to_content()
    local content = {}
    self:fill_object(content, "encoder", self._encoder)
    self:fill_object(content, "force_source", self._force_source)
    self:fill_object(content, "fragmenter", self._fragmenter)
    self:fill_object(content, "fragment_size", self._fragment_size)
    self:fill_content(content, "highlight_query", self._highlight_query)
    self:fill_object(content, "no_match_size", self._no_match_size)
    self:fill_object(content, "number_of_fragments", self._number_of_fragments)
    self:fill_object(content, "order", self._order)
    self:fill_object(content, "phrase_limit", self._phrase_limit)
    self:fill_object(content, "pre_tags", self._pre_tags)
    self:fill_object(content, "post_tags", self._post_tags)
    self:fill_object(content, "require_field_match", self._require_field_match)
    self:fill_object(content, "type", self._type)

    local field = {}
    field[self._key_name] = content
    return {field}
end

return highlighter_fields
