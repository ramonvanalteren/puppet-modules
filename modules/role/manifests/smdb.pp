# This defines the smdb vagrant node

class role::smdb inherits role
{
    package {
        "flask":
            category => "dev-python",
            ensure => latest;
        "sqlalchemy":
            category => "dev-python",
            ensure => latest;
    }
    include mysql
}
