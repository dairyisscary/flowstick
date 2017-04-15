module Styles.Reset exposing (css)

import Css exposing (..)
import Css.Elements exposing (..)


css : Stylesheet
css =
    stylesheet resetSnippets


resetSnippets : List Snippet
resetSnippets =
    [ each
        [ html
        , body
        , div
        , span
        , selector "object"
        , selector "iframe"
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , p
        , selector "blockquote"
        , pre
        , a
        , selector "abbr"
        , selector "acronym"
        , selector "address"
        , selector "big"
        , selector "cite"
        , selector "code"
        , selector "del"
        , selector "dfn"
        , selector "em"
        , img
        , selector "ins"
        , selector "kbd"
        , selector "q"
        , selector "s"
        , selector "samp"
        , selector "small"
        , selector "strike"
        , strong
        , selector "sub"
        , selector "sup"
        , selector "tt"
        , selector "var"
        , selector "b"
        , selector "u"
        , selector "i"
        , selector "center"
        , selector "dl"
        , selector "dt"
        , selector "dd"
        , ol
        , ul
        , li
        , fieldset
        , form
        , label
        , legend
        , Css.Elements.table
        , caption
        , tbody
        , tfoot
        , thead
        , tr
        , th
        , td
        , article
        , selector "aside"
        , canvas
        , selector "details"
        , selector "embed"
        , selector "figure"
        , selector "figcaption"
        , footer
        , header
        , selector "menu"
        , nav
        , selector "output"
        , selector "ruby"
        , section
        , selector "summary"
        , selector "time"
        , selector "mark"
        , audio
        , video
        ]
        [ margin zero
        , padding zero
        , border zero
        , fontSize (pct 100)
        , property "font" "inherit"
        , verticalAlign baseline
        ]
    , each
        [ article
        , selector "aside"
        , selector "details"
        , selector "figcaption"
        , selector "figure"
        , footer
        , header
        , selector "menu"
        , nav
        , section
        ]
        [ display block ]
    , body [ property "line-height" "1" ]
    , each [ ol, ul ] [ property "list-style" "none" ]
    , each [ selector "blockquote", selector "q" ] [ property "quotes" "none" ]
    , selector "blockquote:before, blockquote:after, q:before, q:after"
        [ property "content" ""
        , property "content" "none"
        ]
    , Css.Elements.table
        [ property "border-collapse" "collapse"
        , property "border-spacing" "0"
        ]
    ]
