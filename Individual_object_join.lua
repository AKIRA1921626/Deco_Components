--[[
Individual_object_join.lua
個別オブジェクトを1つの単一オブジェクトとして統合するモジュール。
]]

local M = {}

function M.object_join(w, h)
    -- index 0 の時にバッファを初期化
    if (obj.index == 0) then
        -- サイズ未指定時は画面サイズをデフォルトにする
        w = w or obj.screen_w
        h = h or obj.screen_h
        
        -- 仮想バッファの作成（初期化）
        obj.setoption("drawtarget", "tempbuffer", w, h)
        obj.clearbuffer("tempbuffer")
    else
        -- 2文字目以降は既存のバッファをターゲットに設定
        obj.setoption("drawtarget", "tempbuffer")
    end

    -- 拡大率と透明度の取得
    -- ※AviUtlの内部仕様により obj.sx 等を統合して扱う
    local scale = obj.sx
    local alpha = obj.getvalue("alpha")

    -- 仮想バッファへの描画
    -- 相対座標(ox, oy, oz)に加えて、バッファ中央(w/2, h/2)を基準にする場合は座標調整が必要
    -- ここでは元のロジックを継承しつつ描画
    obj.draw(obj.ox, obj.oy, obj.oz, scale, alpha, obj.rx, obj.ry, obj.rz)

    -- 最後の文字ではない場合：元の文字を表示させないための処理
    if (obj.index ~= obj.num - 1) then
        obj.setoption("drawtarget", "framebuffer")
        obj.load("tempbuffer") -- バッファをロード
        obj.alpha = 0
        obj.draw(obj.ox, obj.oy, obj.oz, scale, 0, obj.rx, obj.ry, obj.rz)
    else
        -- 最後の文字の場合：統合されたバッファをメインに描画
        obj.setoption("drawtarget", "framebuffer")
        obj.load("tempbuffer")
        obj.clearbuffer("tempbuffer")
        -- 描画後は他のスクリプトへの影響を防ぐためバッファをクリア
        -- ただし、直後に obj.draw() が呼ばれることを前提とする
        -- obj.clearbuffer("tempbuffer") -- 必要に応じてコメント解除
    end
end

return M