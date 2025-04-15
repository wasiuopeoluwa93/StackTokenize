
;; StacksTokenize -Real World Asset Token Contract
;; Implements advanced features for real-world asset tokenization

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-listed (err u102))
(define-constant err-invalid-amount (err u103))
(define-constant err-not-authorized (err u104))
(define-constant err-kyc-required (err u105))
(define-constant err-vote-exists (err u106))
(define-constant err-vote-ended (err u107))
(define-constant err-price-expired (err u108))

(define-constant MAX-ASSET-VALUE u1000000000000) ;; 1 trillion
(define-constant MIN-ASSET-VALUE u1000) ;; 1 thousand
(define-constant MAX-DURATION u144) ;; ~1 day in blocks
(define-constant MIN-DURATION u12) ;; ~1 hour in blocks
(define-constant MAX-KYC-LEVEL u5)
(define-constant MAX-EXPIRY u52560) ;; ~1 year in blocks

;; Add new error codes
(define-constant err-invalid-uri (err u110))
(define-constant err-invalid-value (err u111))
(define-constant err-invalid-duration (err u112))
(define-constant err-invalid-kyc-level (err u113))
(define-constant err-invalid-expiry (err u114))
(define-constant err-invalid-votes (err u115))
(define-constant err-invalid-address (err u116))
(define-constant err-invalid-title (err u117))

;; Data Maps
(define-map assets 
    { asset-id: uint }
    {
        owner: principal,
        metadata-uri: (string-ascii 256),
        asset-value: uint,
        is-locked: bool,
        creation-height: uint,
        last-price-update: uint,
        total-dividends: uint
    }
)

(define-map token-balances
    { owner: principal, asset-id: uint }
    { balance: uint }
)

(define-map kyc-status
    { address: principal }
    { 
        is-approved: bool,
        level: uint,
        expiry: uint 
    }
)

(define-map proposals
    { proposal-id: uint }
    {
        title: (string-ascii 256),
        asset-id: uint,
        start-height: uint,
        end-height: uint,
        executed: bool,
        votes-for: uint,
        votes-against: uint,
        minimum-votes: uint
    }
)

(define-map votes
    { proposal-id: uint, voter: principal }
    { vote-amount: uint }
)

(define-map dividend-claims
    { asset-id: uint, claimer: principal }
    { last-claimed-amount: uint }
)

(define-map price-feeds
    { asset-id: uint }
    {
        price: uint,
        decimals: uint,
        last-updated: uint,
        oracle: principal
    }
)

;; SFTs per asset
(define-constant tokens-per-asset u100000)

;; Helper functions for input validation
(define-private (validate-asset-value (value uint))
    (and 
        (>= value MIN-ASSET-VALUE)
        (<= value MAX-ASSET-VALUE)
    )
)

(define-private (validate-duration (duration uint))
    (and 
        (>= duration MIN-DURATION)
        (<= duration MAX-DURATION)
    )
)

(define-private (validate-kyc-level (level uint))
    (<= level MAX-KYC-LEVEL)
)

(define-private (validate-expiry (expiry uint))
    (and 
        (> expiry stacks-block-height)
        (<= (- expiry stacks-block-height) MAX-EXPIRY)
    )
)