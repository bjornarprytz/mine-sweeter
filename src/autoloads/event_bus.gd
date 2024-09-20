class_name EventBus
extends Node2D


# Add signals here for game-wide events. Access through the Events singleton

signal tutorial_reveal_first_cell()

signal cell_revealed(cell: Cell)
signal cell_flagged(cell: Cell)
signal cell_unflagged(cell: Cell)

signal mine_tripped(cell: Cell)
signal mines_confirmed(cells: Array[Cell])
