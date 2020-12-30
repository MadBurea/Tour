
import UIKit
import AVFoundation

class AlarmController: UIViewController {
    
    @IBOutlet final private weak var labelTime: UILabel!
    
    @IBOutlet final private weak var minuteTextField : UITextField!
    @IBOutlet final private weak var secondsTextField: UITextField!
    
    @IBOutlet final private weak var stopButton: UIButton!
    
    private var totalSeconds = 0
    
    private var player: AVAudioPlayer?
    
    var timer = Timer()
    var isTimerRunning = false

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
}

extension AlarmController {
    final private func prepareView() {
        stopButton.isHidden = true
        labelTime.text = "00:00"
    }
    
    final private func validateTextFieldText() {
        if let minute = minuteTextField.text, !minute.isEmpty,
           let seconds = secondsTextField.text, !seconds.isEmpty,
           let intMin = Int(minute), let intSec = Int(seconds){
            totalSeconds = intMin*60 + intSec
            stopButton.isHidden = false
            
            minuteTextField.isUserInteractionEnabled = false
            secondsTextField.isUserInteractionEnabled = false
            
            runProdTimer()
        }
    }
    
    @IBAction final private func didTapOnStop() {
        stopButton.isHidden = true
        minuteTextField.isUserInteractionEnabled = true
        secondsTextField.isUserInteractionEnabled = true
        
        minuteTextField.becomeFirstResponder()
        
        timer.invalidate()
        isTimerRunning = false
        totalSeconds = 0
        labelTime.text = "00:00"
    }
}

extension AlarmController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == secondsTextField {
            if minuteTextField.text?.isEmpty ?? false {
                return false
            }
            return true
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let finalString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if finalString.isEmpty {
            return true
        }
        
        if finalString.count <= 2, let number = Int(finalString), number < 60 {
            return true
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        validateTextFieldText()
        return true
    }
}

extension AlarmController {
    final private func runProdTimer() {
        labelTime.text = prodTimeString(time: TimeInterval(totalSeconds))
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(AlarmController.updateProdTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    @objc final private func updateProdTimer() {
        if totalSeconds < 1 {
            //For Playing Sound
//            playSound()
            
//            AudioServicesPlayAlertSound(SystemSoundID(1350))
//            AudioServicesPlaySystemSound(SystemSoundID(1350))
            
            showAlert(withMessage: "Time Up !!")
            
            isTimerRunning = false
            timer.invalidate()
            labelTime.text = "00:00"
            
            stopButton.isHidden = true
            
            minuteTextField.text = ""
            secondsTextField.text = ""
            
            minuteTextField.isUserInteractionEnabled = true
            secondsTextField.isUserInteractionEnabled = true
        }
        else {
            totalSeconds -= 1
            labelTime.text = prodTimeString(time: TimeInterval(totalSeconds))
        }
    }
    
    final private func prodTimeString(time: TimeInterval) -> String {
        let prodMinutes = Int(time) / 60 % 60
        let prodSeconds = Int(time) % 60
        
        return String(format: "%02d:%02d", prodMinutes, prodSeconds)
    }
}

extension AlarmController {
    final private func playSound() {
        guard let url = Bundle.main.url(forResource: "iphoneRingtone", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    final private func stopSound() {
        player?.stop()
        player = nil
    }
}
