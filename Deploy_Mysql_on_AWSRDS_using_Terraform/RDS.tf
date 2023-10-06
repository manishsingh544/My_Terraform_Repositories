# Create RDS DB using Terraform

resource "aws_db_instance" "myrds" {
  engine              = "mysql"
  engine_version      = "8.0.33"
  allocated_storage   = 20
  storage_type        = "gp2"
  instance_class      = "db.t3.micro"
  identifier          = "mydb"
  username            = "admin"
  password            = "Dorsetdc80#"
  publicly_accessible = true
  skip_final_snapshot = true
  tags = {
    Name = "MyfirstRDSDB"
  }
}
