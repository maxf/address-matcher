module Main exposing (..)

import Html.App as App
import String exposing (toInt)
import Navigation
import State exposing (..)
import View
import Rest


main : Program Never
main =
    Navigation.program urlParser
        { init = init
        , view = View.view
        , update = update
        , subscriptions = always Sub.none
        , urlUpdate = urlUpdate
        }



-- INIT


init : Result String Int -> ( Model, Cmd Msg )
init result =
    let
        userId =
            Result.withDefault 0 result

        initCmd =
            if userId == 0 then
                [ Rest.fetchUsers ]
            else
                [ Rest.fetchUsers, Rest.fetchAddresses ]
    in
        (Model Nothing userId [] []) ! initCmd



-- Page URL Stuff


userIdToUrl : Int -> String
userIdToUrl userId =
    "#" ++ (toString userId)


updateUrl : Int -> Cmd Msg
updateUrl userId =
    Navigation.newUrl (userIdToUrl userId)


fromUrl : String -> Result String Int
fromUrl url =
    String.toInt (String.dropLeft 1 url)


urlParser : Navigation.Parser (Result String Int)
urlParser =
    Navigation.makeParser (fromUrl << .hash)


urlUpdate : Result String Int -> Model -> ( Model, Cmd Msg )
urlUpdate result model =
    case result of
        Ok newUserId ->
            ( { model | currentUserId = newUserId }, Cmd.none )

        Err _ ->
            ( model
            , Navigation.modifyUrl (userIdToUrl model.currentUserId)
            )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchUsers ->
            ( model, Rest.fetchUsers )

        FetchUsersOk users ->
            ( { model | users = users }, Cmd.none )

        FetchUsersFail error ->
            ( { model | error = Just error }, Cmd.none )

        UserChange newUserId ->
            let
                newUserIdAsInt =
                    newUserId |> toInt |> Result.withDefault 0
            in
                { model | currentUserId = newUserIdAsInt }
                    ! [ updateUrl newUserIdAsInt, Rest.fetchAddresses ]

        FetchAddresses ->
            ( model, Rest.fetchAddresses )

        FetchAddressesOk addresses ->
            ( { model | addresses = addresses }, Cmd.none )

        FetchAddressesFail error ->
            ( { model | error = Just error }, Cmd.none )

        SelectCandidate ( selectedCandidateUprn, testId ) ->
            ( { model | addresses = removeAddress testId model.addresses }
            , Rest.sendMatch selectedCandidateUprn testId model.currentUserId
            )

        NoMatch testId ->
            ( { model | addresses = removeAddress testId model.addresses }
            , Cmd.none
            )

        SendMatchOk result ->
            ( model, Cmd.none )

        SendMatchFail error ->
            ( { model | error = Just error }, Cmd.none )
