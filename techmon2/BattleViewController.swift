//
//  BattleViewController.swift
//  techmon2
//
//  Created by Lisa Mizuno on 2021/06/18.
//

import UIKit

class BattleViewController: UIViewController {
    
    //プレイヤーの関連付けするパーツ
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    
    //敵の関連付けするパーツ
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    //音楽再生などで使う便利クラス
    let techMonManager = TechMonManager.shared
    
    
    
    //キャラクターのステータス
    var playerHP = 100
    var playerMP = 0
    var enemyHP = 200
    var enemyMP = 0
   
    
    var player: Character!
    var enemy: Character!
    //ゲーム用タイマー
    var gameTimer: Timer!
    
    //プレイヤーが攻撃できるかどうか
    var isPlayerAttackAvilable: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        //プレイヤーのステータスを反映
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP)/100"
        playerMPLabel.text = "\(playerMP)/20"
        
        //敵のステータスを反映
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP)/200"
        enemyMPLabel.text = "\(enemyMP)/35"
        
        //　ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    
    //0.1秒ごとにゲームの状態を更新
    @objc func updateGame(){
        
        //プレイヤーのステータスを更新
        playerMP += 1
        if playerMP >= 20{
            isPlayerAttackAvilable = true
            playerMP = 20
        }else{
            isPlayerAttackAvilable = false
        }
        
        //敵のステータスを更新
        enemyMP += 1
        if enemyMP >= 35{
            
            enemyAttack()
            enemyMP = 0
        }
        playerMPLabel.text = "\(playerMP)/20"
        enemyMPLabel.text = "\(enemyMP)/35"
        
    }
    
    
    //敵の攻撃
    func enemyAttack(){
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP-=20
        
        playerHPLabel.text = "\(playerHP)/100"
        
        if playerHP<=0{
            finishBattle(vanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool){
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvilable = false
        
        var finishMessage: String = ""
        if isPlayerWin{
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！"
        }else{
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北(T_T)"
        }
     
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK!", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert,animated:true,completion:nil)
    }
    
    
    
    @IBAction func attackAction(){
        
        if isPlayerAttackAvilable{
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemyHP-=30
            playerMP=0
            
            enemyHPLabel.text = "\(enemyHP)/200"
            playerMPLabel.text = "\(playerHP)/20"
            
            if enemyHP<=0{
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
