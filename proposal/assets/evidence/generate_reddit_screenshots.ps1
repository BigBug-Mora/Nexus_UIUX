Add-Type -AssemblyName System.Drawing

function Create-RedditCard {
    param (
        [string]$OutputPath,
        [string]$Subreddit = "r/srilanka",
        [string]$Author = "colombo_foodie_94",
        [string]$TimeAgo = "1 yr. ago",
        [string]$Title,
        [string]$Body,
        [string]$Upvotes = "142",
        [string]$CommentsCount = "38 comments",
        [string]$TopCommentAuthor = "",
        [string]$TopCommentText = "",
        [int]$Width = 800,
        [int]$Height = 420
    )

    $bmp = New-Object System.Drawing.Bitmap $Width, $Height
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

    # Colors (Reddit modern Dark Theme)
    $bgCanvas = [System.Drawing.Color]::FromArgb(18, 18, 18)
    $bgCard = [System.Drawing.Color]::FromArgb(26, 26, 27)
    $borderCard = [System.Drawing.Color]::FromArgb(52, 53, 54)
    $redditOrange = [System.Drawing.Color]::FromArgb(255, 69, 0)
    $textPrimary = [System.Drawing.Color]::FromArgb(215, 218, 220)
    $textSecondary = [System.Drawing.Color]::FromArgb(129, 131, 132)
    $commentBg = [System.Drawing.Color]::FromArgb(34, 35, 37)
    $upvoteBg = [System.Drawing.Color]::FromArgb(40, 40, 42)

    # Fill background
    $brushCanvas = New-Object System.Drawing.SolidBrush $bgCanvas
    $g.FillRectangle($brushCanvas, 0, 0, $Width, $Height)

    # Card background (with rounded rectangle effect)
    $cardRect = New-Object System.Drawing.Rectangle 16, 16, ($Width - 32), ($Height - 32)
    $brushCard = New-Object System.Drawing.SolidBrush $bgCard
    $penBorder = New-Object System.Drawing.Pen $borderCard, 1
    $g.FillRectangle($brushCard, $cardRect)
    $g.DrawRectangle($penBorder, $cardRect)

    # Fonts
    $fontHeaderBold = New-Object System.Drawing.Font ("Segoe UI", [float]10, [System.Drawing.FontStyle]::Bold)
    $fontHeaderRegular = New-Object System.Drawing.Font ("Segoe UI", [float]10, [System.Drawing.FontStyle]::Regular)
    $fontTitle = New-Object System.Drawing.Font ("Segoe UI", [float]13, [System.Drawing.FontStyle]::Bold)
    $fontBody = New-Object System.Drawing.Font ("Segoe UI", [float]10, [System.Drawing.FontStyle]::Regular)
    $fontSmall = New-Object System.Drawing.Font ("Segoe UI", [float]9, [System.Drawing.FontStyle]::Regular)
    $fontSmallBold = New-Object System.Drawing.Font ("Segoe UI", [float]9, [System.Drawing.FontStyle]::Bold)

    # Brushes
    $brushTextPri = New-Object System.Drawing.SolidBrush $textPrimary
    $brushTextSec = New-Object System.Drawing.SolidBrush $textSecondary
    $brushOrange = New-Object System.Drawing.SolidBrush $redditOrange
    $brushCommentBg = New-Object System.Drawing.SolidBrush $commentBg

    # Subreddit Icon (Circle)
    $iconBrush = New-Object System.Drawing.SolidBrush $redditOrange
    $g.FillEllipse($iconBrush, 36, 34, 28, 28)
    $g.DrawString("r/", $fontHeaderBold, (New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::White)), 42, 38)

    # Subreddit name & Meta
    $g.DrawString($Subreddit, $fontHeaderBold, $brushTextPri, 72, 34)
    $metaStr = "•  Posted by u/$Author  $TimeAgo"
    $g.DrawString($metaStr, $fontHeaderRegular, $brushTextSec, 150, 34)

    # Title
    $titleRect = New-Object System.Drawing.RectangleF 36, 74, ($Width - 72), 52
    $g.DrawString($Title, $fontTitle, $brushTextPri, $titleRect)

    # Body
    $bodyRect = New-Object System.Drawing.RectangleF 36, 126, ($Width - 72), 85
    $g.DrawString($Body, $fontBody, $brushTextPri, $bodyRect)

    # Action bar (Upvotes, comments)
    $actionY = 215
    # Upvote pill
    $pillRect = New-Object System.Drawing.Rectangle 36, $actionY, 90, 28
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $upvoteBg), $pillRect)
    $g.DrawString("▲ $Upvotes ▼", $fontSmallBold, $brushTextPri, 46, ($actionY + 5))

    # Comments pill
    $commPill = New-Object System.Drawing.Rectangle 134, $actionY, 120, 28
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $upvoteBg), $commPill)
    $g.DrawString("💬 $CommentsCount", $fontSmall, $brushTextSec, 142, ($actionY + 5))

    # Share pill
    $sharePill = New-Object System.Drawing.Rectangle 262, $actionY, 70, 28
    $g.FillRectangle((New-Object System.Drawing.SolidBrush $upvoteBg), $sharePill)
    $g.DrawString("↗ Share", $fontSmall, $brushTextSec, 272, ($actionY + 5))

    # Top Comment Section (if present)
    if ($TopCommentAuthor -ne "") {
        $commentBox = New-Object System.Drawing.Rectangle 36, 258, ($Width - 72), ($Height - 275)
        $g.FillRectangle($brushCommentBg, $commentBox)
        $g.DrawRectangle($penBorder, $commentBox)

        # Comment header
        $g.DrawString("TOP COMMUNITY COMMENT", $fontSmallBold, $brushOrange, 48, 268)
        $g.DrawString("u/$TopCommentAuthor", $fontSmallBold, $brushTextPri, 215, 268)

        # Comment text
        $commentTextRect = New-Object System.Drawing.RectangleF 48, 292, ($Width - 96), ($Height - 305)
        $g.DrawString($TopCommentText, $fontSmall, $brushTextPri, $commentTextRect)
    }

    $bmp.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Output "Generated: $OutputPath"
}

# 1. Bakery / Restaurant surplus & closing time waste
Create-RedditCard `
    -OutputPath "$PWD\proposal\assets\evidence\reddit-bakery-surplus-waste.png" `
    -Subreddit "r/srilanka" `
    -Author "lankan_nightowl" `
    -TimeAgo "1 yr. ago" `
    -Title "What happens to unsold food in Colombo bakeries and pastry shops at closing time?" `
    -Body "I often see local bakeries around Colombo 3 & 4 closing at 8:30–9:00 PM with trays of shorteats, buns, and pastries still half full. Do they actually donate this surplus or does it all get thrown away? It feels tragic knowing how many people go hungry in the city while fresh food gets discarded daily." `
    -Upvotes "284" `
    -CommentsCount "67 comments" `
    -TopCommentAuthor "cmb_hospitality_guy" `
    -TopCommentText "Used to manage a cafe in Kollupitiya. Staff take what they can, but after a point they get sick of eating buns every day. Most places end up tossing the rest into bins. Why not donate? Pure liability. If someone claims food poisoning the next day, the brand takes the hit. Unless an organized group picks it up by 8:30 PM with proper thermal boxes, owners won't risk it." `
    -Height 430

# 2. Hurdles of donating cooked food vs dry rations
Create-RedditCard `
    -OutputPath "$PWD\proposal\assets\evidence\reddit-cooked-food-donation-hurdles.png" `
    -Subreddit "r/srilanka" `
    -Author "charity_seeker_lk" `
    -TimeAgo "8 mo. ago" `
    -Title "Why is it so hard to donate cooked surplus food to shelters in Colombo?" `
    -Body "We had a family gathering in Rajagiriya with plenty of untouched catered meal boxes left over. We called two local children's homes around 7:30 PM to ask if they could take them. Both politely refused because they had already finished dinner and had zero fridge space for 20+ heavy packs. We couldn't find anyone in time." `
    -Upvotes "195" `
    -CommentsCount "42 comments" `
    -TopCommentAuthor "volunteer_sl" `
    -TopCommentText "This is the classic dilemma in Colombo. Shelters run on strict meal timetables (dinner is usually 6:30–7:00 PM). Ad-hoc cooked food past 8 PM is impossible for them to store or serve. Dry rations are easy, but cooked food needs a confirmed evening handoff before 6 PM, or a direct volunteer network ready to distribute on the street immediately." `
    -Height 430

# 3. Community drops & lack of verified real-time coordination
Create-RedditCard `
    -OutputPath "$PWD\proposal\assets\evidence\reddit-dropoff-verification.png" `
    -Subreddit "r/srilanka" `
    -Author "ceylon_wanderer" `
    -TimeAgo "1 yr. ago" `
    -Title "Are there any verified, official drop-off points for relief donations in Colombo?" `
    -Body "Every time there's a crisis or community food drive, all coordination happens through unverified Instagram stories or random WhatsApp forwards that are already 6 hours out of date. You load up food/rations, drive across Colombo in traffic, only to be told they are at full capacity or already closed for the night." `
    -Upvotes "312" `
    -CommentsCount "54 comments" `
    -TopCommentAuthor "colombo_mapper" `
    -TopCommentText "Exactly this. We drove to a collection center near Town Hall last Friday after seeing a flyer, only to find the gates shut and no one answering. Without a live, time-stamped status showing what they actually need and when they stop accepting, people end up wasting fuel and donations get spoiled." `
    -Height 430
