# This module defines the available stages and their inter dependancy

class stages {
    # Define any stages here
    stage { "bootstrap": } # Used to setup basic stuff that needs to be available
    stage { "install": } # Used to install packages

    Stage["bootstrap"] -> Stage["install"] -> Stage["main"]
}
