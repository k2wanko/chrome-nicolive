###
#
# # chrome-nicolive.coffee
# Author: k2wanko k2.wanko[at]gmail.com
# 
###

# check name space
unless nicolive
  console.error "Defined namespace."
  return

#= require_tree lib

nicolive = window.nicolive =
  host: 'live.nicovideo.jp'
