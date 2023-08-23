terraform {
  required_version = ">= 1.0.0"
}

resource "random_shuffle" "rs" {
  input        = 123 # <= this is invalid
  result_count = 1
}