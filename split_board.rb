#!/usr/bin/env ruby
require './parametric_keyboard'
require 'rubyscad'
extend RubyScad

keymap = [
  # start ROW 0
  [[0,0],1], # esc
  [[1,0],1], # 1
  [[2,0],1], # 2
  [[3,0],1], # 3
  [[4,0],1], # 4
  [[5,0],1], # 5
  [[6,0],1], # 6
  [[7,0],1], # 7
  [[8,0],1], # 8
  [[9,0],1], # 9
  [[10,0],1], # 0
  [[11,0],1], # -
  [[12,0],1], # =
  [[13,0],1.5], # bksp
  # start ROW 1
  [[  0,1],1.5], # tab
  [[1.5,1],1], # q
  [[2.5,1],1], # w
  [[3.5,1],1], # e
  [[4.5,1],1], # r
  [[5.5,1],1], # t
  [[6.5,1],1], # y
  [[7.5,1],1], # u
  [[8.5,1],1], # i
  [[9.5,1],1], # o
  [[10.5,1],1], # p
  [[11.5,1],1], # [
  [[12.5,1],1], # ]
  [[13.5,1],1], # \
  # start ROW 2
  [[   0,2],1.75], # ctrl
  [[1.75,2],1], # a
  [[2.75,2],1], # s
  [[3.75,2],1], # d
  [[4.75,2],1], # f
  [[5.75,2],1], # g
  [[6.75,2],1], # h
  [[7.75,2],1], # j
  [[8.75,2],1], # k
  [[9.75,2],1], # l
  [[10.75,2],1], # ;
  [[11.75,2],1], # '
  [[12.75,2],1.75], # enter
  # start ROW 3
  [[   0,3],2.25], # lshift
  [[2.25,3],1], # z
  [[3.25,3],1], # x
  [[4.25,3],1], # c
  [[5.25,3],1], # v
  [[6.25,3],1], # b
  [[7.25,3],1], # n
  [[8.25,3],1], # m
  [[9.25,3],1], # ,
  [[10.25,3],1], # .
  [[11.25,3],1], # /
  [[12.25,3],1.25], # rshift
  # start ROW 4
  [[0,4],1], # fn
  [[1,4],1], # `
  [[2,4],1.25], # lalt
  [[3.25,4],1.25], # lcmd
  [[4.5,4],2.25], # space 1
  [[6.75,4],2.25], # space 2
  [[9,4],1.25], # rcmd
  [[10.25,4],1.25], # ralt
  [[11.5,4],1], # rctrl
];

right_truncations = [
  [[7,0],:right],
  [[6.5,1],:right],
  [[6.75,2],:right],
  [[7.25,3],:right],
  [[6.75,4],:right]
]

left_truncations = [
  [[7,0],:left], # 6
  [[6.5,1],:left], # t
  [[6.75,2],:left], # g
  [[7.25,3],:left], # b
  [[6.75,4],:left], # space 1
]

# kb = ParametricKeyboard.new(
#   width: 14.5,
#   height: 5,
#   keymap: keymap,
#   truncations: left_truncations,
#   include_cutouts: false
# )
# puts kb.plate.to_scad
# kb.plate.save_scad('split_board.scad')
# kb.case.save_scad('split_board.scad')
# kb.case.to_scad do |the_case|
#    echo("before")
#    the_case
#    echo("after")
# end

# To generate two pieces on the same scad, translated
require 'stringio'

original_stdout = $stdout

new_stdout = StringIO.new
$stdout = new_stdout

union do
   kb = ParametricKeyboard.new(
     width: 14.5,
     height: 5,
     keymap: keymap,
     truncations: right_truncations,
     include_cutouts: false
   )
   kb.case.to_scad

   translate(x: kb.case_wall_thickness) do
      kb = ParametricKeyboard.new(
        width: 14.5,
        height: 5,
        keymap: keymap,
        truncations: left_truncations,
        include_cutouts: false
      )
      kb.case.to_scad
   end
end

File.open('split_board.scad', 'w') do |f|
   f.puts new_stdout.string
end

$stdout = original_stdout