provider "aws" {
  region = "eu-west-1"
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "my_postgres-group"
  subnet_ids = ["add at least 2 subnets from 2 AZ and seprate them with comma"]
}

resource "aws_db_instance" "default" {
  identifier             = "rotempoc"
  instance_class         = "db.t3.micro"  
  allocated_storage      = 50
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "15.5"
  username               = "yourmastername"
  password               = "useyourown"
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.postgresql_secgroup.id]
  db_subnet_group_name   = "${aws_db_subnet_group.subnet_group.name}"
  skip_final_snapshot    = true
}


resource "aws_security_group" "postgresql_secgroup" {
  vpc_id        = "write your vpc id"
  name          = "postgresql security group"
  description   = "allow inbound to postgresql"
ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
 }
  
}
