terraform {
  required_version = ">= 1.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

variable "QIITA_TOKEN" {} # 環境変数 TF_VAR_QIITA_TOKEN にセットするのがベター

module "qiita" {
  source = "./modules"
  token  = var.QIITA_TOKEN

  posting_date_utc = {
    year  = 2025
    month = 8
    day   = 18
    hour  = 2
    min   = 42
  }

  article = {
    title        = "夏季休業中でも自動投稿する仕組みで対応してみる"
    tags         = ["QiitaAPI", "QiitaCLI", "terraform"]
    private_flag = true
    # organization = "panasonic-connect"
    body = <<EOB
# 投稿テストも兼ねて

夏季休業に入る前に、EventBridgeからAPIを叩いてQiitaへ自動投稿する様に、terraformでサラッと用意してみます。
良かったら使ってみてください。楽です。
複数投稿したい場合は想定していないため、var.prefixを変えて別のtfstateで`terraform apply`することで対応してください。
自動投稿実行後は忘れずに`terraform destroy`を実行してくださいね。

https://github.com/gsolkaga/Qiita-Auto-Publish-tf
    EOB
  }
}
