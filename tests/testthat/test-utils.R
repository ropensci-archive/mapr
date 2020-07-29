test_that("name param works to change taxon name used", {
  skip_on_cran()

  # prepare data
  # library(spocc)
  # res <- occ(query = "Lynx rufus californicus", from = "gbif")
  # spocc_df_1 <- occ2df(res)
  # save(spocc_df_1, file = "tests/testthat/spocc_df_1.rda", version = 2)

  load("spocc_df_1.rda")
  expect_is(check_name(spocc_df_1), "data.frame")
  # column not found
  expect_error(check_name(spocc_df_1, "foobar"))
  # column found
  expect_message((new1 <- check_name(spocc_df_1, "key")))
  expect_named(new1,
    c("name_old", "longitude", "latitude", "prov", "date", "name"))
  # column name given as "name"
  ## no message given
  expect_message((new2 <- check_name(spocc_df_1, "name")), NA)
  expect_named(new2,
    c("name", "longitude", "latitude", "prov", "date", "key"))
})
