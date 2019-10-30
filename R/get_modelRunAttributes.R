

get_modelRunAttributes <- function(input_dmi, ruleset, tbl_atts)
{
  ruleset <- get_ruleset(ruleset)

  atts = paste0(
      "Ruleset: ", ruleset, "; ",
      "Input DMI: ", input_dmi, "; ",
      "MRM Config: ", tbl_atts$mrm_config_name, "; ",
      "MRM Desc: ", tbl_atts$description, ";"
    )

  atts
}

# gets just the ruleset name from a file path to the ruleset
get_ruleset <- function(ruleset)
{
  tmp <- simplify2array(stringr::str_split(ruleset, "/"))
  tmp <- tmp[nrow(tmp),]

  tmp
}
