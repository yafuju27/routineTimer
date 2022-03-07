////「contentsArray」に渡されたデータを保存する必要がある
//import Foundation
////魔法を追加
//protocol BackProtocol{
//    //呪文を用意
//    func backVC()
//}
//class SaveGetModel{
//
//    //Model
//    //アプリ内に値を保存する
//
//    //設計図をインスタンス化
//    var backProtocol:BackProtocol?
//
//
//    //保存機能のメソッドを作成する
//    //「contentsArray」にある「ContentsModel型」の「配列データ」を保存する機能
//    func saveData(contentsArray:[RoutinesModel]){
//        print("saveGetModelのsaveDataが呼ばれた")
//        //JSONEncoder()をインスタンス化
//        let encode = JSONEncoder()
//        //do,try,catch(セットで使う)
//        //contentsArrayをエンコードしてdata型にする
//        do {
//            print("Encodeのdoが呼ばれた")
//            //data型にすることによって、保存する準備
//            let data = try encode.encode(contentsArray)
//            print("⬇︎dataの中身")
//            print(data)
//            print("⬇︎contentsArrayの中身")
//            print(contentsArray)
//            //UserDefaultsにデータを保存
//            UserDefaults.standard.set(data, forKey: "myDairy")
//
//
//        } catch {
//            print("エラー、catchの中身が呼ばれた")
//            //catchの中身はエラーが出た時に呼ばれるが、今回は必要ない
//        }
//
//
//    }
//
//
//
//    //アプリ内から取り出す
//    //エンコードされたデータをデコードする
//    //「contentsModel型」が入る配列(contentsArray)を返す
//    func getData()->[RoutinesModel]{
//        print("saveGetModelのgetDataが呼ばれた")
//        //contentsArrayのインスタンスを準備
//        var contentsArray = [RoutinesModel]()
//        //もし、UserDefaults内にデータが何かあれば
//        if UserDefaults.standard.object(forKey: "myDairy") != nil{
//            print("UserDefaults内にデータがある")
//            //savedValueという変数に「Data型」でぶち込む
//            let savedValue = UserDefaults.standard.object(forKey: "myDairy") as! Data
//            print(savedValue)
//            //デコーダーを作る
//            let decoder = JSONDecoder()
//            //「try? decoder.decode([ContentsModel].self, from: savedValue)」の中身が空じゃないことを保証している
//            if  let value = try? decoder.decode([RoutinesModel].self, from: savedValue){
//                //インスタンス化されたcontentsArrayに先ほど入ってきたものを入れる
//                contentsArray = value
//
//            }
//
//
//        }else{
//            //値が入っていない場合は、何もしない
//            print("UserFefaultsにデータがない")
//        }
//
//        return contentsArray
//    }
//
//}
//
//
//
////「何かがある」「!= nil」で表す。
