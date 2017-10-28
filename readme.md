# 高専祭企画IPPONグランプリ用画面表示プログラム
このプログラムは、熊本高専の文化祭で開催されたIPPONグランプリ（TV番組を真似た企画）のために、2015年10月に岩崎先生が開発されたProcessingプログラムです。
そのプログラムをメンテナンスしてリリースしました。
操作にはパソコンのキーボードを用います。
環境構築などを含めて、詳細は[evernote](https://www.evernote.com/l/Aaivl6OGiCdO8YYh-0l1EWzrv8A7xe2A_0Q)を御覧ください。

# キーボードの操作方法

a〜zキー     審判の加点（人数に合わせてaから順番に割り当て）  
0(ゼロ)キー  背景を切替（カメラ<-->白色）  
1〜9キー     カメラの切替（カメラの台数に合わせて1から順番に割り当て）  
TABキー     リセット  
ENTERキー   ポイントの表示  
\+         次の問題へ進む  
\-         前の問題へ進む  

# 設定ファイル setup.csv
setup.csvにはカメラの情報と審判の人数を記述します。  

format  
line 1>カメラ1のID,（カメラが2つ以上あれば）カメラ2以降のID, ・・・  
line 2>審判の人数  

ここで、カメラIDはCameraInfo.txtを参考に決定します。
CameraInfo.txtは一度正常に起動すると作成されます。

# BGM
BGMに、以下の音源を使用しています。
+ [フリー音楽素材 Senses Circuit](http://www.senses-circuit.com/)
+ [On-Jin 〜音人〜](http://on-jin.com/)
