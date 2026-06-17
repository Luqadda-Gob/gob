param(
    [string]$Source = "assets/branding/gob-source.png",
    [string]$PngOutput = "assets/branding/gob.png",
    [string]$IconOutput = "assets/windows/gob.ico",
    [string]$WizardOutput = "assets/windows/gob-wizard-small.bmp"
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

public static class GobBrandAssets
{
    public static void Build(string sourcePath, string pngPath, string iconPath, string wizardPath)
    {
        using (var source = new Bitmap(sourcePath))
        using (var transparent = ExtractLogo(source))
        using (var iconSource = FitSquare(transparent, 1024, 48))
        {
            iconSource.Save(pngPath, ImageFormat.Png);
            WriteIcon(iconSource, iconPath, new[] { 16, 24, 32, 48, 64, 128, 256 });
            WriteWizardImage(iconSource, wizardPath);
        }
    }

    private static Bitmap ExtractLogo(Bitmap source)
    {
        var width = source.Width;
        var height = source.Height;
        var candidates = new bool[width * height];
        var visited = new bool[width * height];
        var largest = new List<int>();

        for (var y = 0; y < height; y++)
        {
            for (var x = 0; x < width; x++)
            {
                var color = source.GetPixel(x, y);
                var saturation = color.GetSaturation();
                var brightness = color.GetBrightness();
                candidates[(y * width) + x] =
                    saturation > 0.18f && !(brightness > 0.72f && saturation < 0.55f);
            }
        }

        for (var index = 0; index < candidates.Length; index++)
        {
            if (!candidates[index] || visited[index])
            {
                continue;
            }

            var component = new List<int>();
            var queue = new Queue<int>();
            queue.Enqueue(index);
            visited[index] = true;

            while (queue.Count > 0)
            {
                var current = queue.Dequeue();
                component.Add(current);
                var x = current % width;
                var y = current / width;

                Enqueue(x - 1, y, width, height, candidates, visited, queue);
                Enqueue(x + 1, y, width, height, candidates, visited, queue);
                Enqueue(x, y - 1, width, height, candidates, visited, queue);
                Enqueue(x, y + 1, width, height, candidates, visited, queue);
            }

            if (component.Count > largest.Count)
            {
                largest = component;
            }
        }

        if (largest.Count == 0)
        {
            throw new InvalidOperationException("No colored logo pixels were found.");
        }

        var result = new Bitmap(source.Width, source.Height, PixelFormat.Format32bppArgb);
        foreach (var index in largest)
        {
            var x = index % width;
            var y = index / width;
            var color = source.GetPixel(x, y);
            result.SetPixel(x, y, Color.FromArgb(255, color.R, color.G, color.B));
        }

        return result;
    }

    private static void Enqueue(
        int x,
        int y,
        int width,
        int height,
        bool[] candidates,
        bool[] visited,
        Queue<int> queue)
    {
        if (x < 0 || y < 0 || x >= width || y >= height)
        {
            return;
        }

        var index = (y * width) + x;
        if (!candidates[index] || visited[index])
        {
            return;
        }

        visited[index] = true;
        queue.Enqueue(index);
    }

    private static Bitmap FitSquare(Bitmap source, int size, int padding)
    {
        var bounds = FindContentBounds(source);
        var available = size - (padding * 2);
        var scale = Math.Min((double)available / bounds.Width, (double)available / bounds.Height);
        var width = Math.Max(1, (int)Math.Round(bounds.Width * scale));
        var height = Math.Max(1, (int)Math.Round(bounds.Height * scale));
        var x = (size - width) / 2;
        var y = (size - height) / 2;

        var result = new Bitmap(size, size, PixelFormat.Format32bppArgb);
        using (var graphics = Graphics.FromImage(result))
        {
            graphics.Clear(Color.Transparent);
            graphics.CompositingMode = CompositingMode.SourceCopy;
            graphics.CompositingQuality = CompositingQuality.HighQuality;
            graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
            graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
            graphics.SmoothingMode = SmoothingMode.HighQuality;
            graphics.DrawImage(source, new Rectangle(x, y, width, height), bounds, GraphicsUnit.Pixel);
        }

        return result;
    }

    private static Rectangle FindContentBounds(Bitmap image)
    {
        var left = image.Width;
        var top = image.Height;
        var right = 0;
        var bottom = 0;

        for (var y = 0; y < image.Height; y++)
        {
            for (var x = 0; x < image.Width; x++)
            {
                if (image.GetPixel(x, y).A <= 8)
                {
                    continue;
                }

                left = Math.Min(left, x);
                top = Math.Min(top, y);
                right = Math.Max(right, x);
                bottom = Math.Max(bottom, y);
            }
        }

        if (left > right || top > bottom)
        {
            throw new InvalidOperationException("No visible logo pixels were found.");
        }

        return Rectangle.FromLTRB(left, top, right + 1, bottom + 1);
    }

    private static void WriteIcon(Bitmap source, string path, int[] sizes)
    {
        var images = new List<byte[]>();

        foreach (var size in sizes)
        {
            using (var resized = new Bitmap(size, size, PixelFormat.Format32bppArgb))
            using (var graphics = Graphics.FromImage(resized))
            using (var stream = new MemoryStream())
            {
                graphics.Clear(Color.Transparent);
                graphics.CompositingMode = CompositingMode.SourceCopy;
                graphics.CompositingQuality = CompositingQuality.HighQuality;
                graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
                graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
                graphics.SmoothingMode = SmoothingMode.HighQuality;
                graphics.DrawImage(source, 0, 0, size, size);
                resized.Save(stream, ImageFormat.Png);
                images.Add(stream.ToArray());
            }
        }

        using (var stream = File.Create(path))
        using (var writer = new BinaryWriter(stream))
        {
            writer.Write((ushort)0);
            writer.Write((ushort)1);
            writer.Write((ushort)sizes.Length);

            var offset = 6 + (16 * sizes.Length);
            for (var i = 0; i < sizes.Length; i++)
            {
                writer.Write((byte)(sizes[i] == 256 ? 0 : sizes[i]));
                writer.Write((byte)(sizes[i] == 256 ? 0 : sizes[i]));
                writer.Write((byte)0);
                writer.Write((byte)0);
                writer.Write((ushort)1);
                writer.Write((ushort)32);
                writer.Write((uint)images[i].Length);
                writer.Write((uint)offset);
                offset += images[i].Length;
            }

            foreach (var image in images)
            {
                writer.Write(image);
            }
        }
    }

    private static void WriteWizardImage(Bitmap source, string path)
    {
        using (var result = new Bitmap(58, 58, PixelFormat.Format24bppRgb))
        using (var graphics = Graphics.FromImage(result))
        {
            graphics.Clear(Color.White);
            graphics.CompositingQuality = CompositingQuality.HighQuality;
            graphics.InterpolationMode = InterpolationMode.HighQualityBicubic;
            graphics.PixelOffsetMode = PixelOffsetMode.HighQuality;
            graphics.SmoothingMode = SmoothingMode.HighQuality;
            graphics.DrawImage(source, 3, 3, 52, 52);
            result.Save(path, ImageFormat.Bmp);
        }
    }
}
'@

$sourcePath = (Resolve-Path $Source).Path
$pngPath = [System.IO.Path]::GetFullPath($PngOutput)
$iconPath = [System.IO.Path]::GetFullPath($IconOutput)
$wizardPath = [System.IO.Path]::GetFullPath($WizardOutput)

New-Item -ItemType Directory -Force ([System.IO.Path]::GetDirectoryName($pngPath)) | Out-Null
New-Item -ItemType Directory -Force ([System.IO.Path]::GetDirectoryName($iconPath)) | Out-Null
New-Item -ItemType Directory -Force ([System.IO.Path]::GetDirectoryName($wizardPath)) | Out-Null

[GobBrandAssets]::Build($sourcePath, $pngPath, $iconPath, $wizardPath)

Write-Output "Created $pngPath"
Write-Output "Created $iconPath"
Write-Output "Created $wizardPath"
