//
//  BIP39.swift
//  LibWally
//
//  Created by Sjors on 27/05/2019.
//  Copyright © 2019 Blockchain. All rights reserved.
//

import Foundation

struct BIP39Mnemonic {
    let words: [String]

    init?(_ words: [String]) {
        if (!BIP39Mnemonic.isValid(words)) { return nil }
        self.words = words
    }

    static func isValid(_ words: [String]) -> Bool {
        // Check that each word appears in the BIP39 dictionary:
        if (!Set(words).subtracting(Set(BIP39WordList)).isEmpty) {
            return false
        }
        return true
    }

}

var BIP39WordList: [String] = {
    // Implementation based on Blockstream Green Development Kit
    var words: [String] = []
    var WL: OpaquePointer?
    precondition(bip39_get_wordlist(nil, &WL) == WALLY_OK)
    for i in 0..<BIP39_WORDLIST_LEN {
        var word: UnsafeMutablePointer<Int8>?
        defer {
            wally_free_string(word)
        }
        precondition(bip39_get_word(WL, Int(i), &word) == WALLY_OK)
        words.append(String(cString: word!))
    }
    return words
}()
