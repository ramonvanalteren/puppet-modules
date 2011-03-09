# This defines the smdb vagrant node

class role::smdb inherits role
{
    package {
        "flask":
            category => "dev-python",
            ensure => latest,
            notify => "Installing $name";
        "sqlalchemy":
            category => "dev-python",
            ensure => latest,
            notify => "Installing $name";
    }
    include mysql
}
