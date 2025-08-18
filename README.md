# Qiitaに自動投稿するAWS EventBridgeを構築するTerraform

cronで日時を指定し、記事内容を事前に用意してAPIにPOSTするだけです。
`terraform apply`時に以下のパラメータを設定する事で動作します。

| 変数名 | 設定箇所 | 説明 |
|:-|:-:|:-|
| TF_VAR_QIITA_TOKEN | 環境変数 | Qiitaに投稿できる権限を持ったトークン |
| var.prefix | terraform | 接頭辞を付与します。デフォルト"QAP_"です。複数展開する際に変更してください。|
| var.posting_date_utc | terraform | 投稿予定日をUTCで指定します |
| var.article | terraform | 投稿内容を記載します |

## 呼び出し方のsample

https://github.com/gsolkaga/Qiita-Auto-Publish-tf/sample.tf
