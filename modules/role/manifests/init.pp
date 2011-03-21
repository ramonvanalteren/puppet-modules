# This is the default that gets applied to every role


class role {
    # Pick up any defined stages and their order
    include stages
    include hostname
    # We can't do much without portage
    include portage
}
