/* ToDo
・ニックネームを残す（cookie）
・ワニをだす
・体力制?
*/

enchant(); // おまじない

window.onload = function() {

    var game = new Game(320, 320); // ゲーム本体を準備すると同時に、表示される領域の大きさを設定しています。
    game.fps = 24; // frames（フレーム）per（毎）second（秒）：ゲームの進行スピードを設定しています。
    game.preload('./img/chara1.png', './img/start.png', './img/gameover.png', './img/bg1.png', './img/icon0.png', './img/igaguri.png', './img/retry_button.png'); // ゲームに使う素材を、あらかじめ読み込む

    // キーの設定
    game.keybind(' '.charCodeAt(0), 'a'); // スペースキーをaボタンに設定

    game.onload = function() { // ゲームの準備が整ったらメインの処理を実行します。
        //タイトルシーンを作り、返す関数
        var createTitleScene = function() {
            var scene = new Scene();                                // 新しいシーンを作る
            scene.backgroundColor = '#fcc800';                      // シーンの背景色を設定
            // スタート画像設定
            var startImage = new Sprite(236, 48);                   // スプライトを作る
            startImage.image = game.assets['./img/start.png'];     // スタート画像を設定
            startImage.x = 42;                                      // 横位置調整
            startImage.y = 136;                                     // 縦位置調整
            scene.addChild(startImage);                             // シーンに追加
            // タイトルラベル設定
            var title = new Label('kuma is ready');                     // ラベルを作る
            title.textAlign = 'center';                             // 文字を中央寄せ
            title.color = '#ffffff';                                // 文字を白色に
            title.x = 0;                                            // 横位置調整
            title.y = 96;                                           // 縦位置調整
            title.font = '28px sans-serif';                         // 28pxのゴシック体にする
            scene.addChild(title);                                  // シーンに追加
            // サブタイトルラベル設定
            var subTitle = new Label('- tap to start -');  // ラベルを作る
            subTitle.textAlign = 'center';                          // 文字中央寄せ
            title.x = 0;                                            // 横位置調整
            subTitle.y = 196;                                       // 縦位置調整
            subTitle.font = '14px sans-serif';                      // 14pxのゴシック体にする
            scene.addChild(subTitle);                               // シーンに追加

            // スタート画像にタッチイベントを設定
            scene.addEventListener(Event.TOUCH_START, function(e) {
                game.replaceScene(createGameScene());    // 現在表示しているシーンをゲームシーンに置き換える
            });

            // シーンに「aボタン（スペースキー）プッシュイベント」を追加
            scene.addEventListener('abuttondown', function(){
                game.replaceScene(createGameScene());    // 現在表示しているシーンをゲームシーンに置き換える
            });

        // この関数内で作ったシーンを呼び出し元に返します(return)
        return scene;
    };

    // ゲームシーンを作り、返す関数
    var createGameScene = function(){
        var appleDropSpeed = 7;   // りんごの落ちてくるスピード
        var igaguriDropSpeed = 8;   // 栗の落ちてくるスピード(初期値)
        var scene = new Scene();                // 新しいシーンを作る
        var points = 0; // 獲得ポイントを記録する変数
        var frameNum = 0; // くまをスムーズに動かすのに必要な変数を用意しておく

        // 背景の設定
        var bg1 = new Sprite(320, 320);            // スプライトを作る
        bg1.image = game.assets['./img/bg1.png']; // 画像を設定
        bg1.x = 0;                                 // 横位置調整
        bg1.y = 0;                                 // 縦位置調整
        scene.addChild(bg1);                       // シーンに追加

        // キャラクターの設定
        var kuma = new Sprite(32, 32);  // くまというスプライト(操作可能な画像)を準備すると同時に、スプライトの表示される領域の大きさを設定しています。
        kuma.image = game.assets['./img/chara1.png']; // くまにあらかじめロードしておいた画像を適用します。
        kuma.x = 160; // くまの横位置を設定します。
        kuma.y = 250; // くまの縦位置を設定します。
        scene.addChild(kuma); // ゲームのシーンにくまを表示させます。
        kuma.frame = 5; // 静止くま
        var speed = 2; // くまのスピードを表す変数（箱）を用意しておきます。

        // キャラクターの当たり判定用スプライトの設定
        var kuma_hit = new Sprite(1, 1);           // スプライトを作る（幅1, 高さ1）
        kuma_hit.x = kuma.x + kuma.width / 2;      // 横位置調整 くまの左右中央に配置
        kuma_hit.y = kuma.y + kuma.height / 2;     // 縦位置調整くまの上下中央に配置
        scene.addChild(kuma_hit);                  // シーンに追加

        // りんごの設定
        var apple = new Sprite(16, 16);          // スプライトを作る
        apple.image = game.assets['./img/icon0.png']; // 画像を設定
        apple.scale(2, 2); // りんご画像を2倍の大きさで使用
        apple.frame = 15;
        apple.x = -apple.width;                // 横位置は仮置き
        apple.y = -apple.height*2;                // 縦位置調整 画面外に隠しておく
        scene.addChild(apple);                   // シーンに追加

        // Todo いがぐりの個数を変数化したい
        //// いがぐりスプライトを幾つも作らない方法はないか…？

        // いがぐりの設定(1個目)
        var igaguri1 = new Sprite(42, 31);          // スプライトを作る
        igaguri1.image = game.assets['./img/igaguri.png']; // 画像を設定
        igaguri1.x = -igaguri1.width;                // 横位置は仮置き
        igaguri1.y = -igaguri1.height;                // 縦位置調整 画面外に隠しておく
        scene.addChild(igaguri1);                   // シーンに追加

        // いがぐりの設定(2個目)
        var igaguri2 = new Sprite(42, 31);          // スプライトを作る
        igaguri2.image = game.assets['./img/igaguri.png']; // 画像を設定
        igaguri2.x = -igaguri2.width;                // 横位置は仮置き
        igaguri2.y = -igaguri2.height;                // 縦位置調整 画面外に隠しておく
        scene.addChild(igaguri2);                   // シーンに追加

        // いがぐりの設定(3個目)
        var igaguri3 = new Sprite(42, 31);          // スプライトを作る
        igaguri3.image = game.assets['./img/igaguri.png']; // 画像を設定
        igaguri3.x = -igaguri3.width;                // 横位置は仮置き
        igaguri3.y = -igaguri3.height;                // 縦位置調整 画面外に隠しておく
        scene.addChild(igaguri3);                   // シーンに追加

        // スコア表示用ラベルの設定
        var scoreLabel = new Label("");            // ラベルを作る
        scoreLabel.color = '#000000';                 // 白色に設定
        scoreLabel.x = 250;
        scoreLabel.y = 20;
        scene.addChild(scoreLabel);                // シーンに追加

        //  rank(難易度)の設定
        var rank = 1;
        if (points >=5 && points <10){
            rank = 2;
        } else if( points >=10){
            rank = 3;
        }

        // くまがやられた関数
        var kumaDead = function() {
            kuma.frame = 8;                       // くまを涙目にする
            game.pushScene(createGameoverScene(points)); // ゲームオーバーシーンをゲームシーンに重ねる(push)
        };

        // シーンに「aボタン（スペースキー）プッシュイベント」を追加
        scene.addEventListener('abuttondown', function(){
            kuma.tl.moveBy(0, -80, 10, enchant.Easing.CUBIC_EASEOUT) // 10フレームかけて現在の位置から上に移動
            .moveBy(0, 80, 10, enchant.Easing.CUBIC_EASEIN);   // 10フレームかけて現在の位置から元の位置に移動
        });

        // シーンに「タッチイベント」を追加します。
        scene.addEventListener(Event.TOUCH_START, function(touch) {

            // タッチイベントは、タッチした座標をe.x , e.y として取ることができます。
            // なお、eという変数の名前は自由に変更できます。 例：function(好きな名前) {
            if (touch.x > kuma.x+20) { // if (もしも) タッチした横位置が、くまの横位置よりも右側（座標の値として大きい）だったら
                speed = 2*rank; // くまのスピードを2にする
                kuma.scaleX = Math.abs(kuma.scaleX); // 右向き
            } else if (touch.x < kuma.x) { // それ以外のときは
                speed = -2*rank; // くまのスピードを-2にする
                kuma.scaleX = -Math.abs(kuma.scaleX); // 左向き
            } else if (touch.x >= kuma.x && touch.x <= kuma.x+20 && touch.y >= kuma.y-15 && touch.y <= kuma.y+50){
                // くまをジャンプさせる
                kuma.tl.moveBy(0, -80, 10, enchant.Easing.CUBIC_EASEOUT) // 10フレームかけて現在の位置から上に移動
                .moveBy(0, 80, 10, enchant.Easing.CUBIC_EASEIN);   // 10フレームかけて現在の位置から元の位置に移動
            }
        });

        // シーンに「毎フレーム実行イベント」を追加します。
        scene.addEventListener(Event.ENTER_FRAME, function() {
            // 方向キーが押された時のイベントを追加
            if (game.input.right) {
                speed = 2*rank; // くまのスピードを2にする
                kuma.scaleX = Math.abs(kuma.scaleX); // 右向き
            }
            if (game.input.left) {
                speed = -2*rank; // くまのスピードを-2にする
                kuma.scaleX = -Math.abs(kuma.scaleX); // 左向き
            }
            frameNum ++; // フレーム数をカウント（くまの動き用）
            if ((speed < 0 && kuma.x > 0) || ( speed > 0 && kuma.x < 290)) {
                kuma.x += speed; // もしくまが端っこでなければ、くまの座標をspeed分ずらす
                if (frameNum % 4 === 0 || frameNum % 4 == 2 ) {
                    kuma.frame = 5; // 表示フレームを1つずらす// くまを歩かせる
                } else if(frameNum % 4 == 1 ) {
                    kuma.frame = 6;
                } else if(frameNum % 4 == 3 ) {
                    kuma.frame = 7;
                }
                // 端っこだった場合に向きを反転させる
                if(kuma.x === 0){
                    kuma.frame = 5; // 静止くま
                    kuma.scaleX = Math.abs(kuma.scaleX); // 右向き
                } else if(kuma.x == 290) {
                    kuma.frame = 5; // 静止くま
                    kuma.scaleX = -Math.abs(kuma.scaleX); // 左向き
                }
            }
            // 物(いがぐり・りんご)の出現タイミング
            if (points < 5) { // 難易度1
                if (frameNum % 55 === 0) { // 50フレーム毎に
                    apple.y = -apple.height+1; // りんごが出現（チラ見え）
                    apple.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
                if (frameNum % 50 === 0) { // 50フレーム毎に
                    igaguri1.y = -igaguri1.height+1; // いがぐり出現（チラ見え）
                    igaguri1.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
            } else if(points >= 5 && points < 10){ // 難易度2
                igaguriDropSpeed = 12;
                if (frameNum % 55 === 0) { // 50フレーム毎に
                    apple.y = -apple.height+1; // りんごが出現（チラ見え）
                    apple.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
                if (frameNum % 50 === 0) { // 50フレーム毎に
                    igaguri1.y = -igaguri1.height+1; // いがぐり出現（チラ見え）
                    igaguri1.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
                if (frameNum % 75 === 0) { // 75フレーム毎に
                    igaguri2.y = -igaguri2.height+1; // 2個目のいがぐり出現（チラ見え）
                    igaguri2.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
            } else if(points >= 10){ // 難易度3
                igaguriDropSpeed = 16;
                if (frameNum % 55 === 0) { // 50フレーム毎に
                    apple.y = -apple.height+1; // りんごが出現（チラ見え）
                    apple.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
                if (frameNum % 50 === 0) { // 50フレーム毎に
                    igaguri1.y = -igaguri1.height+1; // いがぐり出現（チラ見え）
                    igaguri1.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
                if (frameNum % 75 === 0) { // 75フレーム毎に
                    igaguri2.y = -igaguri2.height+1; // 2個目のいがぐり出現（チラ見え）
                    igaguri2.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
                if (frameNum % 63 === 0) { // 63フレーム毎に
                    igaguri3.y = -igaguri3.height+1; // 2個目のいがぐり出現（チラ見え）
                    igaguri3.x = Math.floor( Math.random() * 280 ); // 横位置を決める
                }
            }

            // 鳥はまだいないのでコメントアウト
            // if (frameNum % 3000 === 0) {// 3000フレーム毎に
            //     bird.x = 320;                // 鳥を右端に出現させます
            // }

            // 当たり判定用スプライトをくまの上下中心に置く
            kuma_hit.x = kuma.x + kuma.width/2;
            kuma_hit.y = kuma.y + kuma.height/2;

            // 障害物の落下とくまとの接触の設定
            if (igaguri1.y > -igaguri1.height) {     // いがぐりが出現している（画面内にある）とき
                igaguri1.y += igaguriDropSpeed;        // いがぐりを落下させる
            }
            if (igaguri2.y > -igaguri2.height) {     // いがぐりが出現している（画面内にある）とき
                igaguri2.y += igaguriDropSpeed;        // いがぐりを落下させる
            }
            if (igaguri3.y > -igaguri3.height) {     // いがぐりが出現している（画面内にある）とき
                igaguri3.y += igaguriDropSpeed;        // いがぐりを落下させる
            }
            if (apple.y > -apple.height) {     // りんごが出現している（画面内にある）とき
                apple.y += appleDropSpeed;        // りんごを落下させる
            }

            if (igaguri1.intersect(kuma_hit) || igaguri2.intersect(kuma_hit) || igaguri3.intersect(kuma_hit)) {// いがぐりとくまがぶつかったとき
                kumaDead();                   // くまがやられた関数を実行
            }

            // くまの向きを取得する関数を用意
            function direction(n) {
                return (n > 0) ? 1 : (n < 0) ? -1 : 0;
            }

            if(apple.intersect(kuma)){ //りんごとくまがぶつかったとき
                points++;
                kumaDirection = direction(kuma.scaleX);
                kumaScaleYBefore = kuma.scaleY;
                kuma.scaleX = kumaDirection*(1+points/10); // 獲得りんご数に応じてくまのサイズを変更
                kuma.scaleY = (1+points/10);   // 獲得りんご数に応じてくまのサイズを変更
                kuma.y += (kumaScaleYBefore-kuma.scaleY)/2; // くまの縦位置をちょっと上にする。
                apple.y = -apple.height*2; // りんごを消す
            }

            // 鳥はまだいないのでコメントアウト
            // if (bird.x > -bird.width) {           // 鳥が出現している（画面内にある）とき
            // bird.x -= SCROLL_SPEED * 1.2;     // 鳥を1.2倍速でスクロール
            //  if (bird.frame > 0) {             // 鳥のフレーム番号を0, 1, 0, 1と切り替えて羽ばたかせる
            //         bird.frame = 0;
            //      } else {
            //         bird.frame = 1;
            //     }
            // }
            scoreLabel.text = points+' apple'; // スコア表示を更新
        });
        // この関数内で作ったシーンを呼び出し元に返します(return)
        return scene;
    };

    var createGamepauseScene = function() {
        // この関数内で作ったシーンを呼び出し元に返します(return)
        return scene;
    };

    var createGameoverScene = function(points) {
        var scene = new Scene();                                // 新しいシーンを作る
        scene.backgroundColor = '#303030';                         // シーンの背景色を設定

        // キャラクター画像設定
        var scale = 1+points/10; // くまの大きさを変えるための変数を用意
        var kuma = new Sprite(32, 32);  // くまというスプライト(操作可能な画像)を準備すると同時に、スプライトの表示される領域の大きさを設定しています。
        kuma.image = game.assets['./img/chara1.png']; // くまにあらかじめロードしておいた画像を適用します。
        kuma.x = 140; // くまの横位置を設定します。
        kuma.y = 250; // くまの縦位置を設定します。
        kuma.frame = 8; // 泣くくま
        kuma.scale(scale, scale); // 獲得りんご数に応じてくまのサイズを変更
        scene.addChild(kuma); // ゲームのシーンにくまを表示させます。

        // ゲームオーバー画像設定
        var gameoverImage = new Sprite(189, 97);                   // スプライトを作る
        gameoverImage.image = game.assets['./img/gameover.png'];  // ゲームオーバー画像を設定
        gameoverImage.x = 65;                                      // 横位置調整
        gameoverImage.y = 92;                                     // 縦位置調整
        scene.addChild(gameoverImage);                             // シーンに追加

        // ランキングへの遷移画像設定
        var rankingIcon = new Sprite(16, 16);                   // スプライトを作る
        rankingIcon.image = game.assets['./img/icon0.png'];  // icon画像を設定
        rankingIcon.frame = 30; // 星アイコン
        rankingIcon.scale(2, 2); // 画像を2倍の大きさで使用
        rankingIcon.x = 275;                                      // 横位置調整
        rankingIcon.y = 30;                                     // 縦位置調整
        scene.addChild(rankingIcon);                             // シーンに追加

        // スコアラベル設定
        var label = new Label(points+'apples');            // ラベルを作る スコアを代入
        label.textAlign = 'center';                                // 文字を中央寄せ
        label.color = '#fff';                                      // 文字を白色に
        label.x = 10;                                               // 横位置調整
        label.y = 40;                                              // 縦位置調整
        label.font = '40px sans-serif';                            // 40pxのゴシック体にする
        scene.addChild(label);                                     // シーンに追加

        // リトライラベル(ボタン)設定
        var retryLabel = new Label('Try Again');                  // ラベルを作る
        retryLabel.textAlign = 'center';                                // 文字を中央寄せ
        retryLabel.color = '#fff';                                 // 文字を白色に
        retryLabel.x = 0;                                          // 横位置調整
        retryLabel.y = 275;                                        // 縦位置調整
        retryLabel.font = '20px sans-serif';                       // 20pxのゴシック体にする
        scene.addChild(retryLabel);                                // シーンに追加

        // ニックネーム入力欄
        var input = new Entity();
        input.width = 100;
        input.height = 25;
        input.x =80;
        input.y =210;
        input.font = '15px sans-serif';                       // 15pxのゴシック体にする
        input._element = document.createElement('input');
        input._element.setAttribute("name","myText");
        input._element.setAttribute("type","text");
        input._element.setAttribute("value","名無しさん");
        scene.addChild(input);

        // submitボタン
        var submit = new Button("登録");
        submit.moveTo(190, 205); // 位置を調整
        submit.buttonFont = '15px sans-serif';                       // 15pxのゴシック体にする
        scene.addChild(submit);

        // スコアの値をphpに送る関数を作成
        var sendRanking = function(){
          // 送るデータを用意
          nickname = input._element.value;
          var data = {nickname:nickname , points : points};
          //ajax処理
          $.ajax({
            type: "POST",
            url: "post.php",
            data:data,
            success: function(data, dataType)
            {
                enchant.widget._env.dialogHeight = 120;
                enchant.widget._env.font = "15px sans-serif";
                enchant.widget._env.buttonFont = "15px sans-serif";
                var alertScene = new AlertScene("記録を送信しました<br>"+JSON.parse(data), "OK");
                alertScene.onaccept = function() {
                    scene.removeChild(submit);
                    scene.removeChild(input);
                };
                game.pushScene(alertScene);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown)
            {
                alert('Error : ' + errorThrown);
            }
          });
        };

        // 登録ボタンを押した時にdataの値をPHPに送り付ける
        submit.addEventListener(Event.TOUCH_START,sendRanking);

        // リトライラベルにタッチイベントを設定
        retryLabel.addEventListener(Event.TOUCH_START, function(e) {
            game.replaceScene(createTitleScene());    // 現在表示しているシーンをタイトルシーンに置き換える
        });

        // ランキングを表示する関数を作成
        var ranking = function(){
          // 送るデータを用意(空)
          var data = {0 : 0};
          //ajax処理
          $.ajax({
            type: "POST",
            url: "ranking.php",
            data:data,
            success: function(data, dataType)
            {
                enchant.widget._env.dialogHeight = 290;
                enchant.widget._env.font = "15px sans-serif";
                enchant.widget._env.buttonFont = "15px sans-serif";
                var rankingScene = new AlertScene(JSON.parse(data));
                game.pushScene(rankingScene);
            },
            error: function(XMLHttpRequest, textStatus, errorThrown)
            {
                alert('Error : ' + errorThrown);
            }
          });
        };

        // 星アイコンにタッチイベントを設定
        rankingIcon.addEventListener(Event.TOUCH_START,ranking);

        // シーンに「aボタン（スペースキー）プッシュイベント」を追加
        scene.addEventListener('abuttondown', function(){
            game.replaceScene(createTitleScene());    // 現在表示しているシーンをタイトルシーンに置き換える
        });


        // この関数内で作ったシーンを呼び出し元に返します(return)
        return scene;
    };

        // 開始シーンをタイトルシーンに設定(rootSceneをTaitleSceneに置き換え)
        game.replaceScene(createTitleScene());
    };

    game.start(); // ゲームをスタートさせます
    // iOS のアドレスバーを隠す
    window.scrollTo(0, 0);
};
