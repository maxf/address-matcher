module State exposing (..)

import Http exposing (..)
import User exposing (..)
import DataSetInfo exposing (..)
import Address exposing (..)
import Animation exposing (..)
import Animation.Messenger


-- Model
-- TODO: can we remove currentUserId and make the current user the top of the
-- users list?


type alias Model =
    { currentUserId : UserId
    , users : RemoteUsers
    , addresses : RemoteAddresses
    , dataSetInfo : RemoteDataSetInfo
    , animationStyle : Animation.Messenger.State Msg
    }


type Msg
    = FetchUsers
    | FetchUsersOk (List User)
    | FetchUsersFail Http.Error
    | UserChange String
    | FetchDataSetInfo
    | FetchDataSetInfoOk DataSetInfo
    | FetchDataSetInfoFail Http.Error
    | FetchAddresses
    | FetchAddressesOk (List Address)
    | FetchAddressesFail Http.Error
    | NextCandidate ( String, TestId )
    | SelectCandidate ( String, TestId )
    | SendMatchFail Http.Error
    | SendMatchOk String
    | Animate Animation.Msg
