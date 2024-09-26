data "aws_rds_engine_version" "postgresql" {
  engine = "postgres"
}

resource "aws_db_instance" "products" {
  identifier           = "ecommerce-products"
  engine               = "postgres"
  engine_version       = data.aws_rds_engine_version.postgresql.version
  instance_class       = "db.t3.micro"  # Smallest instance size
  allocated_storage    = 20  # Minimum storage for PostgreSQL
  storage_type         = "gp2"
  db_name              = "products"
  username             = "ecommerce"
  password             = var.db_password
  parameter_group_name = "default.postgres${split(".", data.aws_rds_engine_version.postgresql.version)[0]}"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name

  tags = {
    Name = "ecommerce-products-db"
  }
}

resource "aws_security_group" "rds" {
  name        = "ecommerce-rds-sg"
  description = "Security group for RDS PostgreSQL instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Note: This allows access from anywhere. For production, restrict this.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-rds-sg"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "ecommerce-rds-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "ecommerce-rds-subnet-group"
  }
}