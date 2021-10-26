// Sergiy Radyakin, The World Bank, 2021

// Example code for creating an empty database of projects and adding a single project there.

clear all

// Create an empty database for ADePT SP projects
adept_sp_projbase_create

// Populate the created database
adept_sp_projbase_add, projfile("sp_testing.adept")
adept_sp_projbase_add, projfile("sp_testing.adept")
adept_sp_projbase_add, projfile("sp_testing.adept")
adept_sp_projbase_add, projfile("sp_testing.adept")

// Show resulting data
list
frame PROGS: list, sepby(projid)

// END OF FILE
