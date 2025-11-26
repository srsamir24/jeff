/**
 * Composable for handling Supabase Storage uploads
 * Provides utilities for uploading images to the 'projects' bucket
 */
export const useSupabaseStorage = () => {
  const client = useSupabaseClient();
  const config = useRuntimeConfig();

  /**
   * Upload a file to Supabase Storage
   * @param file - File object to upload
   * @param path - Optional path within the bucket (e.g., 'projects/image.jpg')
   * @returns Public URL of the uploaded file
   */
  const uploadFile = async (file: File, path?: string): Promise<string> => {
    const bucket = "projects";

    // Generate a unique filename if path not provided
    const fileName = path || `${Date.now()}-${file.name.replace(/\s+/g, "-")}`;

    // Upload the file
    const { data, error } = await client.storage
      .from(bucket)
      .upload(fileName, file, {
        cacheControl: "3600",
        upsert: false,
      });

    if (error) {
      console.error("Upload error:", error);
      throw new Error(`Failed to upload file: ${error.message}`);
    }

    // Get the public URL
    const {
      data: { publicUrl },
    } = client.storage.from(bucket).getPublicUrl(data.path);

    return publicUrl;
  };

  /**
   * Upload multiple files to Supabase Storage
   * @param files - Array of File objects to upload
   * @returns Array of public URLs
   */
  const uploadFiles = async (files: File[]): Promise<string[]> => {
    const uploadPromises = files.map((file) => uploadFile(file));
    return Promise.all(uploadPromises);
  };

  /**
   * Delete a file from Supabase Storage
   * @param path - Path to the file within the bucket
   */
  const deleteFile = async (path: string): Promise<void> => {
    const bucket = "projects";

    const { error } = await client.storage.from(bucket).remove([path]);

    if (error) {
      console.error("Delete error:", error);
      throw new Error(`Failed to delete file: ${error.message}`);
    }
  };

  /**
   * Get the file path from a public URL
   * @param url - Public URL from Supabase Storage
   * @returns File path within the bucket
   */
  const getPathFromUrl = (url: string): string => {
    const match = url.match(/\/projects\/(.+)$/);
    return match?.[1] || "";
  };

  /**
   * Trigger file picker and upload selected file
   * @returns Public URL of the uploaded file, or null if cancelled
   */
  const pickAndUploadFile = async (): Promise<string | null> => {
    return new Promise((resolve) => {
      const input = document.createElement("input");
      input.type = "file";
      input.accept = "image/*";

      input.onchange = async (e) => {
        const file = (e.target as HTMLInputElement).files?.[0];
        if (!file) {
          resolve(null);
          return;
        }

        try {
          const url = await uploadFile(file);
          resolve(url);
        } catch (error) {
          console.error("Upload failed:", error);
          resolve(null);
        }
      };

      input.oncancel = () => resolve(null);
      input.click();
    });
  };

  /**
   * Trigger file picker and upload multiple selected files
   * @returns Array of public URLs, or empty array if cancelled
   */
  const pickAndUploadFiles = async (): Promise<string[]> => {
    return new Promise((resolve) => {
      const input = document.createElement("input");
      input.type = "file";
      input.accept = "image/*";
      input.multiple = true;

      input.onchange = async (e) => {
        const files = Array.from((e.target as HTMLInputElement).files || []);
        if (files.length === 0) {
          resolve([]);
          return;
        }

        try {
          const urls = await uploadFiles(files);
          resolve(urls);
        } catch (error) {
          console.error("Upload failed:", error);
          resolve([]);
        }
      };

      input.oncancel = () => resolve([]);
      input.click();
    });
  };

  return {
    uploadFile,
    uploadFiles,
    deleteFile,
    getPathFromUrl,
    pickAndUploadFile,
    pickAndUploadFiles,
  };
};
