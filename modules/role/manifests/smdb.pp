# This defines the smdb vagrant node

class role::smdb inherits role
{
    notify { "Installing packages: flask & sqlalchemy": ; }

    package {
        "flask":
            category => "dev-python",
            ensure => latest,
            ;
        "sqlalchemy":
            category => "dev-python",
            ensure => latest,
            ;
    }
    include mysql
}
