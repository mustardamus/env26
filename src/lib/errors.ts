import { ClientResponseError } from "pocketbase";

export function errorToFlatObject(err: Error) {
  const errObj: Record<string, string> = {};

  if (err instanceof ClientResponseError) {
    const keyNames = Object.keys(err.data.data || {});

    if (keyNames.length) {
      for (const keyName of keyNames) {
        errObj[keyName] = err.data.data[keyName].message;
      }
    } else {
      errObj.general = err.response.message;
    }
  } else if (err instanceof Error) {
    errObj.general = err.message;
  } else {
    errObj.general = "Unknown Error";
  }

  return errObj;
}
